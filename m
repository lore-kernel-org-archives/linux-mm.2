Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A32D6CC6B30
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 10:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42BC86B0088; Thu, 15 Oct 2026 06:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BC2A6B008A; Thu, 15 Oct 2026 06:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E0B6B008C; Thu, 15 Oct 2026 06:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5A406B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:54:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 573334093B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:54:15 +0000 (UTC)
X-FDA: 85324551270.27.646A821
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4A7D420005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:54:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eLFJz2i3;
	spf=pass (imf31.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792061653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GiFJNEdHCyl9o7lyZvAVM97bzBWzN9FAsadD1M92V8=;
	b=PVW8h+NN3hTTLZSwvyZZg7tcrfgk3gLLwJERJnkyef98R006VUfNQIImVHeq+duaw7CQOq
	kJxlLG9Olof3pXMps9oOTQ57NCSY9I7EWCwn9Hj7+7t+2W41wKnZMBVW5kR28kDkWQZUFo
	pqJASQfSloroiVzfcXAzw6amY29nxKo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792061653;
	b=oRxtaKqV1tUUMUZYdnXKWm0vtxPDqH6RJhMmQ6dYE2NFr7/bWQf43Qn+7APSP09+VMj6Xw
	Eiv2bdxTE2wWcmOW8IqG+vLGi3dGfxYc76Rbx0Y3JESfm9dukEJwnN3fatG5OQfVrWf5RR
	58tEgA8Nv8cx0vqWbSYblm9mBDNXT3c=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=eLFJz2i3;
	spf=pass (imf31.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48c4be28b82so273023f8f.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792061652; x=1792666452; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7GiFJNEdHCyl9o7lyZvAVM97bzBWzN9FAsadD1M92V8=;
        b=eLFJz2i3X4pCdsjXyzK9mKy5aNqURfLOmOjyrU9+2acFR5hmLQGwP/sylX/QDNVoYp
         +Hw89bVO628i0VKRf7QpKtpANKeI5y1UcpQIc8EPZ4/LCItCN4hPraNW9Sxtgf/4lwVv
         6IKDct1CCVHR41isKkQvGOL+PP6CWmodfGV6GUwrLmkj18+VpzGwpdyI5cm9eVNyIQii
         yvkzYP3Yit6LBsUr/YuxWpagd58nSvA+o5N4tc5rbvjdQpCS6+pYSa5C6ThW12FE0LFv
         ULtF3ajbSG29l4o3F2W9mFOcpI+ZGBi4yz0FLKtSX7gRAxnoA632IFWQmjk4hJpGVfOy
         +h9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792061652; x=1792666452;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=7GiFJNEdHCyl9o7lyZvAVM97bzBWzN9FAsadD1M92V8=;
        b=DNcTqtwrxF0Ghslk3iWwGnIV6yMuQq1YkelYkhIDlcHypCthE5IhH9fFL6+grvKKwt
         sD9bDQL45WewKGjbEr9IZi3hZe9roe1ldp0fvtdrxabxsjVQcweYKndOT5wIyJl/l7Km
         Y66frt1K/LgGSYlLeA/0ZXIpt9CJ2bLm1RUQM2z+OwbfD417nLuZxsZQPf7iOONoI3s6
         Ev8ZMLTIXF9bMrlPXhprnryuY+9ww69OmgKHwYoV+lXXm3x1Roe7yYoaSW7rBztU2zXn
         sHfQ5HHwgsyma19Y/DU6WuUd98Y4pA7Q+9sViThhFdtKzPYXm2NmeuY7hVw9bKADGJC6
         cftg==
X-Forwarded-Encrypted: i=1; AKwUvBzCOD16YKLgq5pileUbqzYNBM6/unujq+Px1JcPsryIyZk8u7v99g3gBjVTYngfG48pcU0YjAMDlA==@kvack.org
X-Gm-Message-State: AFq9FYIpCAWK0Z6dN/Rcoy4/ZnAoi1EqJHT0+bEFomHAZuvJtm5Xkw7t
	GmRsDflSO+00Lm0i3GY6QCm3TObdrXJbEtxUp1TjSDifHnQAAtFFsPyHySArtII0HO4=
X-Gm-Gg: AYBFou0+awAI/23OZssAGsqjthokPhlEECo8rHiFYni1xr9jlqim0B7rOOKVsnYwB8v
	zvd0n4MCb9iEE1goRxJSme6VwfKLTC1YWfHhqnnMvMNfaG4kGe7Csjy9pzKrlcrTkJ06o7eIuuT
	bGpQqvrpjjVlyECcNrNGar+0rKJ/BZVzQ/J27O3Dt4h9Zjrfk/c4LpPAHRzVNSQtsvOGCAoj3iV
	BfJLCSoshzeNaOjLQghadqffeugSwVU/maYquAgUMVMHVW96kr7Hy+8BbsALYlN5PpXL5ykdmBw
	j7uyZ0NfaIW/ngh3iLrElUUepZAIzdnsrzKxFI8gAPXcDc+Tq/3KDwkZHfd46VF9n9kf+XIcplR
	PX6ijdojkiwfmL0YkmUQKBukI8lm24Dr8moaHLQAAlW11FhQl0lk/uNHxcGtt4UDdDOy0MBNguN
	uN46jd+SpcpdmZZVsu/9LzeKDYmVyCfOwwgQAXvL0bji0uQerGcO6ZntPL8EI53G411Ow1oSUcV
	PcXsNvC+WzH
X-Received: by 2002:a05:6000:388:b0:48d:ed0a:e064 with SMTP id ffacd0b85a97d-48ded0ae0b8mr9811826f8f.24.1792061651748;
        Thu, 15 Oct 2026 03:54:11 -0700 (PDT)
Received: from localhost (109-81-30-108.rct.o2.cz. [109.81.30.108])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de77606fbsm10461734f8f.53.2026.10.15.03.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 03:54:11 -0700 (PDT)
Date: Thu, 15 Oct 2026 12:54:10 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH] proc: Move OOM-related procfs code to fs/proc/oom.c
Message-ID: <atCw0gk77fF5ISQV@tiehlicka>
References: <20261014-oom_procfs-v1-1-f2d75e73571e@linux.dev>
 <as9MG_BtepLV6DsC@tiehlicka>
 <e51c14e9-5559-4ff7-8a38-de815a8f8230@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e51c14e9-5559-4ff7-8a38-de815a8f8230@linux.dev>
X-Rspamd-Queue-Id: 4A7D420005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gr8gaubty587g8tymfdg9oar1ai13i6r
X-HE-Tag: 1792061653-562010
X-HE-Meta: U2FsdGVkX18nQCsK6n4eLq/Tn+0IykJCdBcOhXiXyL0J+5LoCOI24hgwGerOvgxiP0fErdsN99ux6eYAnN4nbyuX6S4xvE0bVqvOmBRd8RGMVZXoRQFYb4fWD9Zar1zkQz2iQ2ii4rwAzVCAPz0VcAbJcAtYFc0Aveu30Opv3qS2+yb54i5lhnrwcXy6ePOXyRC3ay+YVWbPD0bNJB1b+PrZOIb3eAGtjbcUPS+9kQbki5sq3FJJ/zkEFc9u2Bdxt3IwDHNGfARjGl86BIETT7YOS75r+SX+KZb7i6p+UOgRhqR+jKjsQQJG8UQ5nfjObr2s4IytWeEEZXIHAVfZ9ndWdromMiRHMCoipPSFUT7z9j1OESTbotJvAvhHrPASazhsAG/zA1W8yXM+bFs7CD/ZpOvsW4DFGpUd2oJjlF57PTmkOyz0ddfshQcPfToqN1y/hjCIa9zxtgRApJovuWlW6Dn2LymorFptrZt1sfTC3bGD10NwEbe/+39AD824jrDAWF5Lv1vEogXcyUQ1VNCrF3HtVWptxd/Wtu22Id0ADtyC9kcP6/5Mb90NH1/VTyEsnBxwSGwTz1eq3U/JTY1rXlXD/jeCWTJulYCKAm27W1+BNqqtXspVWMq2USUtf2isazw5vhIqBAkoOMrNQzg695DHfYVtpbZ1/6Cq5VjhDQVtOdeyvVzMvPkTTRxjNZ+oG3uY8oLvIgXFHe7EiERirxHc+rXZ36H140ukbfocH61ng6O1fKK6L7n+WTqZ35wvoy6NWND9Ft9vuxjHIDgMlZTXhRhbgSUZnpgCIIYn1RpL3sYUMeeOgxupVZzKGPlJHabjV8+2bHMAi+3TqbC/HNxTibNPpcvogzIdM1ArqpcfujiB9H63VzFMVyO8o57DTsSvSFQBhkAIXV7ypQd/+wdUX6VuFqhgvH4SIubnecD75eNi01IHWlCYDbKlXacaPRdZfsvD+IDnQwX
 IOchPQct
 8IGEB8zK8GXVjLuF/glALNd3qR/I6RjF0D+KZx9T9kUhcgFi/7qLz8Y1QdFGROWLZQQZx0sgsYS+RpqdY0bTygdx0rEBXIGYvLbwdZwOISr1lxDsbxqAu8tQAXerjRvES/lVtRGA3KB/V7Xqhe3KzysyCvr335ge5JeCoI+H7AKCUmzkdFQna6tpmcGFHP0zaRKgtUj3IK49GGYaHhhLfzGcS1quSf9Mhjp4pHfLNgCkb6Kg4GUVJ/lpCd3Tsci7B7vpj2USF09+jW3tt37gcMklId/QZkBF3vVxwWY27A3bfzycGmuf5XJjZ2gqbgxeGIpx9rpHrYT7L4fimot5SscMsPdh6ciQb2Yus1Dpf2JCbjbpWHw3wiYNH5yhgvzZPX7rM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 15-10-26 09:32:53, Ye Liu wrote:
> 
> 
> 在 2026/10/14 17:32, Michal Hocko 写道:
> > On Wed 14-10-26 16:54:12, Ye Liu wrote:
> >> From: Ye Liu <liuye@kylinos.cn>
> >>
> >> fs/proc/base.c is a large file (~3700 lines) handling all per-process
> >> procfs entries. The OOM score, oom_adj, and oom_score_adj interface
> >> code is self-contained and has no dependencies on other parts of
> >> base.c, so move it into a dedicated fs/proc/oom.c following the same
> >> pattern as fs/proc/fd.c and fs/proc/task_mmu.c.
> >>
> >> This makes both files easier to read and keeps OOM-related procfs
> >> entries together in one place.
> > 
> > Are there plans to separate other functionality or is this one off
> > thing?
> > In general I am not against of moving stuff to more specialized files.
> > An obvious downside is a review as it is quite easy to overlook a subtle
> > change when moving so much code. Something worth undertaking if there
> > is a bigger goal. Not so sure if this is just a one of and fs/proc/base.c
> > still keeps other random stuff in.
> > 
> 
> Hi Michal,
> 
> This is a one-off move specifically for the OOM-related procfs code.
> I don't have a broader plan to split up fs/proc/base.c at this time.
> 
> I understand the concern about subtle changes during code moves.
> To address that, the patch is a pure relocation with no functional
> modifications — all function bodies are moved verbatim. 

But you do understand that I effectivelly need to redo the patch to
confirm this is the case, right?

This is something I am not particularly thrilled to do for a single
isolated patch without a larger plan. taks_mmu.c will remain a huge pile
of code after this change. So what's the point for all that effort?

-- 
Michal Hocko
SUSE Labs

