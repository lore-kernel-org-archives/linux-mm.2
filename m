Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A772C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 00:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506B16B0005; Sat, 27 Jun 2026 20:31:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4901C6B0088; Sat, 27 Jun 2026 20:31:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359F86B008A; Sat, 27 Jun 2026 20:31:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A60E6B0005
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 20:31:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 836831C17C5
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:31:27 +0000 (UTC)
X-FDA: 84927442614.12.A68DF39
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id B24E7140003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 00:31:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EeNiOkpO;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782606685;
	b=vKGUMPdh36RRfsgxHSMPFi9ZuMO/3yj90yqvvsvSwPelybb5z6Er66ClA0bTBw8tS63KCj
	4OQ8vW6Ro7phmzDOEmMsr70R02lOUwrbj6nzHLW/Tbxzc3l+Ueu91mOFygKObuQP8l/4fD
	dIr2Si+JUkeMYW0IkbkyBleredrpjZQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782606685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkN+srl6wjGtNu7iwo0FYJ4HSQUHdkfF1SLjXCC02H4=;
	b=dxnvmRY8qlmtEC0455pek8FZchEujkUA5G84k5VcnYM92rKWTIsD2ufuy/oLiHg7liACQJ
	KD2219Mqq5eOh8O/kpAN/WoVnRpuQk1VmRcbhcqVkDiIySzQ4o64ekinOYlRvkVIoxg0oD
	dy+XwjQ8bWwoJcM8djIrcKYE5ZGLyNI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=EeNiOkpO;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92c7a0a701aso53400985a.3
        for <linux-mm@kvack.org>; Sat, 27 Jun 2026 17:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782606685; x=1783211485; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wkN+srl6wjGtNu7iwo0FYJ4HSQUHdkfF1SLjXCC02H4=;
        b=EeNiOkpOo6sRs5KHXq0spfJaNmA6JaphW90OYFNekUXdhvfdJcj2d9aY17vrq7nBgQ
         epJ9newFCj+IdInw4GZf1Kb2v56SSs9lYrREJJRfmY9tiIS/v3cpRc2baQRK0dHmSFeL
         k5o4XYjwdNO4bFblqbraDUzdlUTwmZNMBoly9aK4U7ZzFPqk9GqNzDl0hpJGywPiWeiJ
         8BNjL7T5hbGNux7dcVJK/lydSDvmXcW+zS8x755jHiP59YG5FdIRNojPbrvLh1edb/nr
         mNkdz8BpiKWvwzQDR0lOh/46KSEfnuZ/YvDnlQuToKqsdSlTb/OEeiPbaVF+QWg/yq7a
         qiMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782606685; x=1783211485;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wkN+srl6wjGtNu7iwo0FYJ4HSQUHdkfF1SLjXCC02H4=;
        b=cKgoWPLtI0YWt3LlXwjL+LSXjWirvMtcLs6LimEymJdTdGjiLGD+ISH7SwI6Q4nJf7
         2ic7cSGyiAR0O0ft71dl1N3590tfXec+1Kpv33hyyTEkWefzPRiLPwJx0AvN+3CelJ3c
         u87BdbH6RN9anwhMCelZNo5g1XV/+uUNdpVenJ77z/ZGA1XqHBtnO+P/z9Hb0qlc2lIJ
         Usww0pIpoPwent9damLbbSC3CVHLNb5raXigHy5BA3AGrzBFUQG965ViWNq2YNmO/kNE
         v78qEVD3kVcvc7HbfPliiGWZwTjSA+KO6VdZ8ObooILGC2VP78YNXkltjBCC+nmrC/7J
         oV/Q==
X-Gm-Message-State: AOJu0Yy2ig9Q54H7cdMC6S6WcZYEQFDBFdNcK2KbG0NEE47rl5g24Bd5
	aS7v6ysdHuNclcq4YSLjYhhUzZLsqUYCmogiMOVy0IhG+Kq9RDYjnyuzC7qvYq9nXHE=
X-Gm-Gg: AfdE7ckDpxLaoHuZrMYNWT8ND+Ibvncu042pRkmmP+iUB+ThnjqrOIBjPojyL6M4fYY
	gbyLYngQfVE++o4v/9OdOf6dK4mSLbuwaXgyeKLHBPwGDM/Q9Zig7duy6IdMwJIS4We1dqpYZfS
	goIBlYIHMkkNE7AwTa52Xi91tsBL846Vdh+Khoxpb55Xey7V8kv7W9Ts79MBJn4d/zERHqQpL4W
	0+mGbay///lE4nTd6nPwTeKijj2wIiNBGRUirzGgLHzL3TaaiiKCrRLt+O0qEcu5JYdTrFvVx0u
	TQkR5QWYm3KtiIvCSVCkFgxFvSkov51ZS5YEG+DkjMIe6Lk6GIM/a1AYeCYpkaUOKeMCTzMFWat
	Iloj8dA+k6XtmEi/Puc+c9Hk1zX4onfrc9hEtALK0deUDWtfQw8JRm9gNfNR4ZxKN2dPDYIB47J
	pTNvyx5owLl5KM/bPPJ4hnAPiNf9w7cGPLmC6XefjejG9xo9GJTuoiBjHnvz2in0akH2fs
X-Received: by 2002:a05:620a:2b90:b0:915:7fe4:cac5 with SMTP id af79cd13be357-92b3e96cd68mr914439085a.49.1782606684710;
        Sat, 27 Jun 2026 17:31:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-926000c31b4sm1637191585a.23.2026.06.27.17.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 17:31:24 -0700 (PDT)
Date: Sat, 27 Jun 2026 20:31:18 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	rppt@kernel.org, vbabka@kernel.org, mgorman@techsingularity.net,
	hannes@cmpxchg.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmstat: fold stranded per-cpu node stats when a
 node comes online
Message-ID: <akBrVoku9tKstb9n@gourry-fedora-PF4VCD3F>
References: <20260627202243.758289-1-gourry@gourry.net>
 <20260627161007.81e4533ce561c2951a69f927@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260627161007.81e4533ce561c2951a69f927@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B24E7140003
X-Stat-Signature: fgepfuaetywghh1hcgdk17rwiy59ckmu
X-HE-Tag: 1782606685-928664
X-HE-Meta: U2FsdGVkX18hU0oEey1uy0AwjaeJk8plIlicdZn+ai8Om4uXy8g17wwJFxii4rUkaVY/VwLvLLR0jbZVrr5rBOLjy2IAGei5tIkRC8fI20MhbGQOfJ1ScnPIKVcMmgMw62zgLKBA+xEMVwWVJoiOD6gbw7GHNDZgAcuO7dtDpR9eQOJ1h8SQ3yK3YNmeEON+H682/BbGU1FN7AQsioRaQ53V83vlIIqupJsjIA/CkJvUopWjsOE/MpgeDtv1A/Utb6FYG5r+Si4yyDp1ROsS9A22x5Jt7D3U63C00HbmiN9JAtQvZjj1WjDNZCzqCsDCXYXJDtW7qfqzIMOQfSPjrcBSeUWa9uXK4qUCTIgWcr4mGLRS8BrfYK9XDg4Xw/5+TJGfAM0e5cd0YiBHFV8HL2dlBiu9P4LHQq8GZSCwOnVisKUeBysUc+HaRf6FkmxaPmG+aWww/XQ+rgtIosJbVvJEZrUgUTVO+1M3eAhdqltctcWEeGONnwY2rlqKkSKFMspBShlC9dyevJqY+j57ytrrfHbgYcU3S9hvU58iYOjQIibDuTqLmr35EIuqfYlutwF0ObgNEpC7i1BZPPIciSL23REKognkvtk5o+R3SK+hpZVBjV8Ttqnv5XclmlQJavTt7KNlYhPrZAbcQ+geM9j5HH1wf6qNETxdaGeh85oY10GvNjTE3p1VCRCVjWEEjtHxSQllPHZ41ARXgBzszpkEmfRUgNyUm/BRqRlUqZI4z2ubEGtk6b7oIjZXeU3mwQhu+R9TIYL82pjeic3cWXWchO7QOWrpYGiNrGJRc23krZ3b8c3GQIud05Pnw2nqKSsgruGxCW1Ks0RebEMy0dDFfuGpeXEmLb3Y/HeyE7/a/oyDd2WtR/GPsYA/7IZBkRFd10S4QXaakPExubzep71ohk67xgnXQa8nxHXAiyWylphNZyI9servg7yXrU8dyw/FG9Iax+4kJFkUcKA
 dchQsexl
 ibrZmsp8vOJLOlzlBiCfGGktJUt89PABtbBKsaUEMZW9NPGrQ2cvUEUl1rMQ9ahTtpVQUWdj+UJUKoNqEE0sVNdnc7pdU6Wz8WaH4y5JrMX9dFrlhlmBlp5xzSXWVwyalvfWBBfAOrBTwpf9NF47Q/ykuj4ck00KbGkxKa8azfeaAGDi4X7wwm9NiX7FxWbRlOs3qgTuZhO2Z1xHA3OdDdswrIyQ3R3pymFa3V1OgkB4nkeoo6SFLBkew6C7UrM5CTYg6OwoBvaYb0qbhLTaFEFMqb9QiMm1HpzpmtWAdTrZqashGl9wkkOzmkusTxisi10OliPUq12QL1mY0SDVYcZn24YTIKD7wIucNHZ26kR6ithaapJb9xzKCUizzV43FRBnQi9eb14ZTuiLyd0nrPylpv9KRlBoMmKEQcodqwSMn62s8aEDo+zmJzWitJRDC1yDg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 27, 2026 at 04:10:07PM -0700, Andrew Morton wrote:
> 
> > The existing code zeroes the per-cpu counters and causes a permanent
> > skew. Fold the stranded deltas instead, before the node rejoins the
> > online set. The node is not online yet and the hotplug lock is held,
> > so the remote access to per-cpu values is safe.
> 
> Oh.  Shouldn't we be doing this during offlining?
>

I tried this first.  I was unable to convince myself there was a 
safe way to accomplish this.

1) sashiko pointed out we can't schedule_on_each_cpu while holding
   the hotplug lock because we'll re-take cpus_read_lock and cause
   a deadlock condition with cpu-hotplug.

2) I'm not sure we can do it after the hotplug lock as been dropped,
   at least not safely.  At the very least another hot-plug re-adding
   the node could start.  That just seemed like a bad path.

3) foreign cpu access to the per-cpu values are not atomic with
   respect to in-flight folds on the target cpu.  this_cpu_xchg
   and this_cpu_add are (i believe) only atomic wrt the cpu itself
   (can't be interrupted mid-exchange).

doing it before node_offline() has problems (in-flight folds),
doing it after node_offline() still *technically* carries the same
in-flight fold risk - just narrower (fold has to have started already).

I couldn't convince myself there wasn't still a race, so here we are.

> > +	for_each_possible_cpu(cpu) {
> 
> That's a lot of CPUs
> 

Unfortunately - cpus may have gone offline while the node was offline,
so we legitimately have to visit every *possible* cpu :[

> > +		struct per_cpu_nodestat *p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
> >  
> > -		p = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu);
> > +		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
> 
> and that's a lot of items.

I am aware :[.  I suppose we could vectorize the collection here on some
archs, but I try to avoid being clever where I can.

> 
> I guess the overall loop count won't be large enough to cause issues,
> but it's large!
> 
> Perhaps there's some simple test we can do on the per_cpu_nodestat to
> avoid the inner loop?  Perhaps might need to add a field for this?

Hadn't considered this, but maybe.  Will take a look.

> 
> btw, "for(int i..." is allowed nowadays.  It'll make this code nicer, IMO.
> 

aye aye o7

> And... Sashiko seems to have found a pre-existing issue:
> 	https://sashiko.dev/#/patchset/20260627202243.758289-1-gourry@gourry.net
> 

Will take a look, thanks!

~Gregory

