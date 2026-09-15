Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91D74C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E5DC6B0096; Tue, 15 Sep 2026 10:13:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56FDE6B0098; Tue, 15 Sep 2026 10:13:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416CD6B0099; Tue, 15 Sep 2026 10:13:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13FBC6B0096
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:13:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 953D6120440
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:13:29 +0000 (UTC)
X-FDA: 85216189338.04.E0ABAEC
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf07.hostedemail.com (Postfix) with ESMTP id C101A40007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:13:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=s673CJl3;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789481607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=So6YxVj9CWW23ILTpr0Fzgp6sAddC6/IZlVCBBvu+Z8=;
	b=htTOcr0fwUjpxBtdkUIjriN/tNFRGtqUrd/wdZQEP6l7uOFvlZvEAaPFgNv32TClrlG9fD
	2Ll3tjZDRnbZTwwIeklnO3wLm9Dxvgsf9tu/p3nnQtevwmYDfXFNhnJy58HdCKAM5HLwxB
	941EdqNGzU6Teq0IiPCY8kSkmRe4F0o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789481607;
	b=lgU9w/7eKzG1gVf0WcSRFTeoaH6WSdw3NVcLjpCEMg6JmMCEgQu1SkB0fvnpV5ibDsFY4y
	qpDwkkGvdPIA3830DADiWQOBTTutrhC3LCGYDl5T5LQNptYnPNS6yUHuaSei4cNLIYLusS
	y4lCn7dk7vKlGfYxn193ZiXw1mzyLqg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=s673CJl3;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-910531ea7feso2423156d6.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789481607; x=1790086407; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=So6YxVj9CWW23ILTpr0Fzgp6sAddC6/IZlVCBBvu+Z8=;
        b=s673CJl3Sqmiw4jtz6k282MUcWdVTduuCRoVGjz7WgP74qfoXflN2Csy8/pecmOvl0
         F3yxXsKVjvZ/qWxsx/qNwcEIiWdacRRSYIvn4TM/P8Gnsx6CYAE8Ua4/7AkrYYn4WovB
         UzJZ42KBIdfCtAyDnzev7lFUMmFeo+t8UQDrSmPu5/W5pWllp3/FxkvUSMnRsOQzo9IY
         fRIF2m0umFwWiByXfx4nsUmeDTtIg8G40wthBUgkCoKbcadWUGQr90oxKbWQGuj/aH2/
         STQaZoSLilgNn6UPXBuKVYAKNwKTB8XDclHvoVoIY9jNdEhv26dV2lx762iZdrjJnUQQ
         gfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789481607; x=1790086407;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=So6YxVj9CWW23ILTpr0Fzgp6sAddC6/IZlVCBBvu+Z8=;
        b=dAoDkURzQ8vJV+Z8M4YdvIdO5r4zjQsTxrcDTQGnKwdcCK9zomkjyy6Uybc2NcyQdv
         YDMUQ9KGPLSZs91Asbd1KQ3aHgC1ulb+mTetJdF1zv2JgKHhvEa6BwjolP0UA4InX7QD
         5pxYMcb3tJzVfELPp+R+yjwp7FEpKZr0agWs0GHMR794tSq3I0Ns8aIzL5wr/NGGzhfS
         xZ44xjmRh4F8VwpzvB5zxadEOU/0GmvL4v6pFq2EhX+hR+EQrFtoiRaDr8fxc4vtESmQ
         yZpgQljHB6rCBUDdaJpxkAgazPqG7dT+0o0pZuQQiX3WRUmyXDwngjZA6jjHgn6TyB8n
         aMCg==
X-Gm-Message-State: AFuF++ml4n/ik/jV1jsfgONKRlBSGFMbBxckLQHxEhSXL9EyIky1Jvxf
	yP9R1k/aqK8nOS3kcKzmFIKvehmpWwrsWCA3GqcJyARdn3DJ8ZyR7vbokhwTY0dS5d8=
X-Gm-Gg: AYBFou1xe51hBRUxHbJQxjzZsKg2w3ptp/tU20XjQ+HO0+29e3Q4oNxbK/qRa4z9tp+
	+J/ElfUFs/WIiKY9XL18yBBJyRX2iOlZEk64S3r7rVn8fxKFsWna8v8I4nBzVarRT881zZE01fI
	k2nVrdvd3e+8lvrEs0wQ0zB5f5lLupPzKpRgrdIKjpO9P/Sb1keC6VDs5sH4NsQJuur35tSq+AS
	U14QDQdktCWjs85ozt7XXxfl9arfT1eqEYzRd4XdA1B8lkhJomUgxhSigGTsKyetooeYTOFXzX0
	TfPJFuziN3eeQfJDWYBcmFzg0+l0d1rjh5qvMkIfHWqRf/s4kr14rgLeO+NG6DG4QWbEzgeyDEW
	061uXHWfiOt1DzJCk18a1raErFApmk7/C90tRIX9CnAbmKOrYaHjdjALxN/9gXlq5LLv3ZE+XwM
	x9OKQyb0O/tBO9RuDZ6dqogW8rAxXncp9/Qx7OjRAD1d5QuAsmNYr01OQBuanwLc72Ohe8eiyjB
	a7foQa9gybi+GPTD7jaPP6QZrwPzoizljOkOfs111aMvfJol3deA9k=
X-Received: by 2002:a05:622a:143:b0:530:fe5e:becf with SMTP id d75a77b69052e-5312622984emr15784801cf.39.1789481606657;
        Tue, 15 Sep 2026 07:13:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-530ca4ba156sm127632851cf.19.2026.09.15.07.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 07:13:26 -0700 (PDT)
Date: Tue, 15 Sep 2026 10:13:24 -0400
From: Gregory Price <gourry@gourry.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	liam@infradead.org, ljs@kernel.org, david@kernel.org, vbabka@kernel.org, 
	jannh@google.com, wangjiexun@tinylab.org, sashiko-bot <sashiko-bot@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reclaim isolated folios if PTE restart fails
Message-ID: <aqlRJbY5mlmjhEzj@gourry-fedora-PF4VCD3F>
References: <20260912110832.3203902-1-gourry@gourry.net>
 <20260914233209.3fd5a6e848ee82d13e43a301@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914233209.3fd5a6e848ee82d13e43a301@linux-foundation.org>
X-Stat-Signature: r9cfow713qdysixqp9dnw3ih474othxr
X-Rspam-User: 
X-Rspamd-Queue-Id: C101A40007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789481607-874369
X-HE-Meta: U2FsdGVkX19S9dsdcuSEOe+MDAVXCY61qV/jdDN0ZnTvRfO2WJKGypgfhVy1n/52Hmn0GqnwD17hY9S/2O2q6cTB1EzcspUwqErxTE21p33MxRls3aR01zVLNL2w9+EvUrmEqjCHAMI/GEn9uJqZumbPQQJnctv5yJZXOBGxFfbZpkTRNSB3yoFoHqfA0ktjteVXGi/MAu35wcFPscBqTIeHYOk8QaSEkeIF/rU6b5+4peEkDQgm2BFmdnkiVW0fJonCQqupU2YVXsEeNDtKxx09IciGnAU0qRQvjIoG/2IQkcqmSpOX/Ztuf6Dji1Q+E1v/873vqm7vei6ERClrG/Ydo/ituuG4IejPTR7KURyRPMqFFu5l2kZsiJlAOrjW4zGorZW9g2iI033Z8cmDo899ntHwTAbvlKx5p/k9t0ORIl16M8enQ9dJQVJjy3om2ACr7f5/A7cLifa37xOdZtgDWu5v5wnI9uDzgbyaxF0QZSkls8VwMyznC63s7lyVxnCHmqWiMuoW7CCCtXLPVoq051ih/ZiUE0WMG84vErPnOm0xpPW3DDy3WvA03jYhkaBqMbbUzLiKACTvJubWUCCndIqpx37wycjxjOm1lgrK++Uyft2eaURBnSX3ApSKjiW3c77L7+znMkYL+HHByXHhvUS63shWWru+S4g/APDrlj3ThYI12tI6VtVd8J3pTV11fbu1hoGZNRt+d7gbnel+Wx2ODmAZZCEQrz24i0QhFI3ZMeKzweuVEQ3AKm4O+tAA1PohbSesak0mIOg+K+InkXtvuTpmzOTDMyxAeKLl6B/YPmZL0wMI408NAyREzu8pxEUPOiQmTnT9HyGvQceoDcdN7A94Qibtt7UVrpLF6UkARUOtzMNlDyHJzFIikuGGoQiWuonMAKP6S1foPhdweHzO1BsDJo8ryNIUuntkBdJYb6dcWU/6N6ENLRYobcAdhtW540Se4f6Yagf
 uQdbF9W/
 QhOI2OqgnaqHKU+5Vguq5/qSW6MYKLWdSXbyF/Q3oj5MhdzvpN3pm6cyPlrqxzT0vnl15eogXcPd3ChPSDD7BQEfYYC4Dew4VrbuzaF22NFBuYXtk1AxfREHotCMfUI1q2gKOsbi7E1FT2JtIQWdsEi1vgFQUhOrjUL+u3kct6Cf8Tq86IJ60Fd824qmzi2TUaE52ZJvPq1FZEUCPQMSQrsxVkhr7h9000YROPdQg4+t3y6pEn1XWCh1i4RUMdX1FtJRV6Lq7kqTJRh7sT3RuBMS10kr+IoNKAitk12fATFb+U25lKycQXkApGFzzftmfYzLV4seJf56VjbJErQEU42U/bAgKrnkaYNzcRlPEcQ1/zgck++ob/SvuOlUdKbrpFnVKo4hnz1ik4eZ4QMTiLqeGuM5XpgZd6Ny1B2qzSwRq1EXVgi4cnc9kRZi3NHmhGwrYLZQpaUmneD3uoBPNWi6vTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:32:09PM -0700, Andrew Morton wrote:
> On Sat, 12 Sep 2026 07:08:32 -0400 Gregory Price <gourry@gourry.net> wrote:
> 
> > MADV_PAGEOUT collects isolated folios on a local list before reclaiming
> > them after the PTE walk.  The reschedule path drops the PTE lock and then
> > restarts the mapping with pte_offset_map_lock().
> > 
> > A concurrent operation can remove or replace the PTE table while the lock
> > is dropped, causing pte_offset_map_lock() to return NULL.  Returning directly
> > in that case bypasses reclaim_pages(), leaving the collected folios off the
> > LRU with elevated references.
> 
> aw man, you got so close then left us hanging.
> 
> So what happened next?  Machine crashed?  Permanent leak?
> 

Permanent leak.

nr_isolated_anon increases reliably and does not decrease when the
process dies.

> > 
> > Fixes: b2f557a21bc8 ("mm/madvise: add cond_resched() in madvise_cold_or_pageout_pte_range()")
> > Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> > Closes: https://sashiko.dev/#/patchset/20260821150912.183976-1-gourry@gourry.net
> > Cc: <stable@vger.kernel.org>
> 
> #include "Documentation/process/stable-kernel-rules.rst"
> 
> (sorry, getting snarky.  I'm saying this stuff 100x/day at present and
> it just isn't sticking).
> 
> > Assisted-by: LLM
> 
> Can I suggest you update LLM's prompts so it checks that the changelog
> includes userspace-visible runtime effects and so that it checks that
> the patch is approximately compliant with stable-kernel-rules?
> 
> If you do, please share that prompt with me and I'll put it in ~/.signature
> 

I typically (re)write (or at least heavily edit) the messages to ensure I
actually understand what's going on.  I'll update my brainmeats.

I get it though, rather than permanent leak say how to observe said leak
(vmstat or etc). ack :]

~Gregory

