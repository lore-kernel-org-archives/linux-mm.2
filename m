Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC670C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A6216B0099; Mon, 27 Jul 2026 12:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85A1F6B009B; Mon, 27 Jul 2026 12:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795BA6B00A6; Mon, 27 Jul 2026 12:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5166B0099
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:37:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF6CB80136
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:37:49 +0000 (UTC)
X-FDA: 85035113058.18.FAD3234
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf10.hostedemail.com (Postfix) with ESMTP id 04669C000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:37:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Fct/ofub";
	spf=pass (imf10.hostedemail.com: domain of 3WolnagYKCGUVHDQMFJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--seanjc.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3WolnagYKCGUVHDQMFJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OOLQnJ1N4T9NlMm3RNk8fL/QgxOWSeQeUY1L1gTRIqQ=;
	b=DXeGJO3+pR4vp/+i+39gBogxcOrmhlpNUholo5Wz8dwTpq/PrhacvChwmr1cQtaf5hvl1K
	JqTvGTga7ZlJiKiebNIvcuCA1DknNqRKzwTmzd1T1OQzugyGrPDKQVNlOzACHdLt4oGDQI
	mWxLouQXmmlstdvfByWpuNPskvZvplA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170268;
	b=IYaon/i8HSqUn0x156sQ8A6GBZDUbGtjtkFUfdhhsHIpL0R5HHR1TJdwy/WepRUQifBJ65
	0hwqqxim5RNPx6CL/s9YlqL4QUuZW6X0kb0YNzpDSy5NlcjH4el07dTfk86y4YUcE3pzx2
	7kiQufLc5i9AEt16LAKBe/Zr8HHP0/w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Fct/ofub";
	spf=pass (imf10.hostedemail.com: domain of 3WolnagYKCGUVHDQMFJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--seanjc.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3WolnagYKCGUVHDQMFJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-848568a6f62so4947264b3a.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785170267; x=1785775067; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OOLQnJ1N4T9NlMm3RNk8fL/QgxOWSeQeUY1L1gTRIqQ=;
        b=Fct/ofubEOneY4zbI7fU0d0cGrZLmEoqFvZDRcBztDCYdYg3nRx4/JPOpnbCBekFy0
         sIbgJDhheinUck2QC0Sko5Ghz23FRPnzTUICvj6Ny1lwEGIyVnVZMgxdW8yhiihgJyIT
         jpfBqiGLRn3Dea/zVecskPwHApG1UH5/eGjUD0/UGJLHDMPJWomJw1w4yit0irvlnogC
         KmUkIckrgyuKRnfuFK28uqE0zCaoErBNlwcMIoAeUiZGPfraSzEO07YkQi2TwfJW8De4
         /Tv144yxM+p1GXGTWWvg85BM9bYzIORLcwFS2SwI3yt+Jd1pg0oMugUpRZFWx+juuV1J
         ExVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785170267; x=1785775067;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OOLQnJ1N4T9NlMm3RNk8fL/QgxOWSeQeUY1L1gTRIqQ=;
        b=eoVQxYkm370HNSGzyM1J542JahOBFijYzCUNGhFIm7lTtd5skWmMMLy2Rc5ljkGoCW
         ZT58ZoSv8R+8rvst7P8gcf1/qs5QtbDDZkATeD80Xnsz9hFu6eQrBYYlwCvhPSdLANg/
         D5EaecD26Jzs0DgGlinNXAIDesij1inSL7ZBEJR6hzCK4zNAJ62OvNFrEje+sEXNjgBD
         qMb6yL1kxSc2g4FGPyIQwSMzzs69W75D9R6PcDDEaT2zTXJNh+FFfewwIQrfNkXmGTTY
         BGXkG5IZiqf/Bfj2b5sFmiANbGYOMOocexHL/OKYbHGcNZTV/Z1Ef00Dncoj3uBix2X0
         N7yw==
X-Forwarded-Encrypted: i=1; AHgh+Rqw3lYh6IlZxKPCWSc1E6xONz2dl0LV4NXs3qGVT7SGchU0+Flq6W7yPcUAQYtTsC5LqY0AOd81ZA==@kvack.org
X-Gm-Message-State: AOJu0Yw73X5YXgGrGkt/xmtZeF1iIQCeZGNRGuldLLUNUcOXo0lFaGX6
	30bAVp0qwzeUMwEez/TAGqBH7OpHVNMhcZy1oIR+Cb6gFdZiz2ehCsKEeg0nUdIm2jGx4fIsI5M
	oVN1wwg==
X-Received: from pfwy37.prod.google.com ([2002:a05:6a00:1ca5:b0:848:7f21:167c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2393:b0:846:2f3c:3f68
 with SMTP id d2e1a72fcca58-84e8d0a7c58mr137097b3a.57.1785170266555; Mon, 27
 Jul 2026 09:37:46 -0700 (PDT)
Date: Mon, 27 Jul 2026 09:37:45 -0700
In-Reply-To: <amLhu07IpWfBbWC0@gourry-fedora-PF4VCD3F>
Mime-Version: 1.0
References: <20260629163337.1264881-1-hannes@cmpxchg.org> <amGpEEqxoLq/Y7ZO@yzhao56-desk.sh.intel.com>
 <amIcXrS7nGX-adpG@google.com> <amIrDncrL4K-JRBO@cmpxchg.org>
 <20260723171515.b5ddbc59c5c36ad01ef8f7fb@linux-foundation.org> <amLhu07IpWfBbWC0@gourry-fedora-PF4VCD3F>
Message-ID: <ameJWWjYXuONB6VF@google.com>
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
From: Sean Christopherson <seanjc@google.com>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, vishal.l.verma@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Stat-Signature: a1rzdxt8dyz9pk9z8ok9cx7c1zuwtuc4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04669C000A
X-HE-Tag: 1785170267-482853
X-HE-Meta: U2FsdGVkX1/NP6lQ3EnAMq19LWdcB+g68dcZUBevLTXszjOVwr4sS2hJuHctewGkAeE/YXjzfJO8/9uX51piJ2gmoGxLkWraWJ+fsnNQtkq/QqWP0niXWHPkEECevQ2srr/aQPw46lM7ij3xPsvoLCM9inCYp/ppEivS+tKxeuOumUVv7mWDC/v5Uwluh8CohRB0jt7snZB+yNUjWhY4gt/r6U1zIgyy9wi/WvPTrkKM7gtXr14vfdbSQ1acjC1WNXyfYCrzazzj59au4usMbMyLXRO9cluX/kerzY9+iqMVO+iqf8wwkxBins6jKuazqB0n/3UYIoLtV7io/w9nWL4oSFePuWjwrwpbX/dAQzd/1v+VjuqYlK6Ua6SiukH2bolGy0QUV3uEDmyg/tQGo/5oQjDg241TkJ6g9jwzqaHjBobKCtvbAhkOpWw8YLZon/ry0gBHWwVgPUFmIdBDQH45RAqM83W2rP4pk8kDj36q1IgKb1BRdJMHNGPjOkQudOLpd7YgFzEke/S7Hok+mV1xLtAZcssQVyCYtzhEHFuxjhMLK4Z4VHwT12+Z+l8jQ6JMg3XdhmeVx+M4LsEJgYyH6h80wKmfJXjJfZMEkGLefqedtA2n/nNou7xETwnhRHPJ0AC4iQniWkWjcFahEI/Y6JsnLHxCvYlvSF7Q0nVC0w0DF2fEdVRG77K3vKOz0BYRNmRTMAkpYNGclftzPR7FwM8kyKMO2WgyyweP/lJuzS8q7xRpEscYh2fr+8P9Za7fmu8yY/xHOHM++Og8uQKkXPLjS68ctHPmBtDzHB9cCIWGSTiePRVOggi9N3iy/HweEzJcNJWjBuScfhfN0yAkHgwshiLFccuyqm3fLroaXNRPBMwOkvbjL3a60SshhsaOn8QsAVb9tyvZIppDE0gbi4mgPQRK4SXYJmmePWNWG/E//UlSk7NqaV4CFMbbflo1rll/IIgBj7yJSpY
 Ik/XmLsj
 Gmb819cl8q6SJeIE2FNl1EIhEIaICrKHzdaUQmUg3H0M4zslPlD6AHieDrMVpRkf/wDJrqAAu70orpey1dTKOmkPBK2oboDOuIEpMKbmGbHbrzhxlJ+G5uPvmWQmLYk3Ea6Dyeee67ULrCxEUtV6s8tZvuXAMCBSgNernIF6FYZWzwt6/zMY4znQrS6KeMe+vQU1jhqWGSLAXrTO1G/lMlMippX9tZDj2JccYHr99IGZ4UfOtVWzyRv+xqbwu5Mo4J8J6SyB/h2p5F1C8hswtR/f+OgU1a+fy1/TrgFcCdPKYo4EeQ4Fu9lyLSc+IvBHF8u0gSyu9+P4xTM3EFPESPNl9YKMbCbDAxMQ1M8XAVBUhOe7rWBAOKFPlTX+XRll84qHphoOvvoKsgzppPNz2mIlhSg6cUTI3WMspnlUsbTndNM0wshNGkMjZUpmtrRFRR4kD6zdEobRZa0OQnb1VXxfDcfj+0TIOVVtYwXSLl3uuBWvuTNGxHMgca68OeSPvakp6/Ac5/JkcoKh5jg8Z/hP8Qv9XPjVoHkHJ+kcUJTDdEmvmb0R7Ex2cV3MBCBRa3LcIU0cRRVxVzy3kvtY2ZW+3fdsD1F4jsCIyWkpeNlX660CwfEAalhr/APkk795os9E82QuUsMCECPhawFF5D9Yn7fzn8QnBqpsDmHRGdR4v94pQXJX+m0dOPFQLJRTTYrFXP4LID/woas3LZO3MmZ87SnHKKhPU0I55
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026, Gregory Price wrote:
> On Thu, Jul 23, 2026 at 05:15:15PM -0700, Andrew Morton wrote:
> > On Thu, 23 Jul 2026 10:54:06 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> > > > But in this case, IIUC, this change will "silently" enable NUMA balancing for
> > > > shmem-based KVM setups where it was previously disabled (albeit unintentionally).
> > > > 
> > > > I'm not fundamentally opposed to the change, but I do worry that downstream KVM
> > > > users could be in for a nasty surprise.
> > 
> > It is a bit concerning.
> > 
> > > This should be very visible in early kernel validation after an
> > > upgrade. VM hosts tend to not do much else, with VM memory dominating
> > > the host. You'd expect a significant uptick in numa_pte_updates,
> > > numa_hint_faults, and a change in per-node nr_shmem stats. And the
> > > patch subject makes it trivial to find in a commit delta scan.
> > 
> > Is there anything we can do to make this process less painful? 
> > Documentation of course, but what about detecting the situation and
> > emitting a once-off warning?
> 
> Maybe a rate-limited or one-time pr_info/warn on the first PROT_NONE
> fault affecting KVM in the painful zap path?
> 
> Non-invasive, targeted, and helpful.

Unfortunately, keying off PROT_NONE probably isn't all that targeted and thus
may or may not be helpful, as it would generate what are effectively false
positives for setups where NUMA balacing is already fully enabled.  In my
experience, KVM users tend to freak out if there's a "scary" kernel message,
even if everything is working exactly how the admin intended.

Thinking about this more, I'm probably being overly paranoid.  The failing KVM
selftest is (very deliberately) about as pathologically stupid as things can get,
i.e. it's not representative of real-world setups.

How about we do nothing for now, and then revisit trying to find a useful way to
alert the end user *if* we start seeing KVM bug reports?  As you said earlier, I
think "You turned numa balancing on" is an acceptable answer at this time.  

