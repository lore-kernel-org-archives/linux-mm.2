Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFE01EED603
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 13:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94A476B0005; Thu,  1 Jan 2026 08:09:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8376B0089; Thu,  1 Jan 2026 08:09:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 804B66B008A; Thu,  1 Jan 2026 08:09:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D40C6B0005
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 08:09:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A2D21A0A36
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 13:09:15 +0000 (UTC)
X-FDA: 84283425870.22.94D3382
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 369EF1C0011
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 13:09:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YZbO+QsB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of aha310510@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=aha310510@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767272953; a=rsa-sha256;
	cv=none;
	b=fR4lHwH/jg8FL+/OltxyOtEaLtJ/TyElh5OYcLKi4Uzl+NNM46G1qmfHKrKO4L/+3dwYOa
	x7pUwhG2OrsZTGDJtaKbETvvodiMURh55QJ9Eaw99g++S2wVX6xt01ep65QEQSeQE/gNRt
	NzAw6fv7sSdXF0Weu0DaF0yjY5oJhhQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YZbO+QsB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of aha310510@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=aha310510@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767272953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nzS+Hy30FELScvyGLAQhm0QHElXtHjtPJGwOfXP5M0s=;
	b=evvwvSwWc6dJMMg5mcdupiOBazWHT+wdS0g1Ql7ZptMRTQw0C/aY4WZQ+cdo7omxFF5l8r
	8kQ9RcP71fvwgczzeG+ONzT/Lb9Bf1CSaJtNUJgzDHy0/SuL+WLHLBas5NMfjLcCb3L8A5
	colRK6EA72tbJ2VFjRQI8yYcsv0yf3w=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a0d5c365ceso151808595ad.3
        for <linux-mm@kvack.org>; Thu, 01 Jan 2026 05:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767272952; x=1767877752; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nzS+Hy30FELScvyGLAQhm0QHElXtHjtPJGwOfXP5M0s=;
        b=YZbO+QsB2mBdegqgetAtuLXlYm3XAjqPrY3NnBn6SenpAB3UIJZHApfV6iw6YM6nhw
         sNwRbDnNgySLhFz65GOyk8/u7W1xqmtLIgmBTIJVjO/MdR5xmKQaewKdQaUs6s9b851J
         PEnLWze/HXOvoraAmH0syZV/4zsCxCtbwJCIb6ymiSFcZEtdamA4B2RAJLDh75xZyGsI
         GidFco/alZmsJphbzgISfrSsWU5+IUCSagC4tC5P4cRMbs/jaEnpzpaZDs3gIt6LiC63
         OCZND7r2Moy6yRpbvRo64YKG0NNsdF3MKLnUBgPk2rOJ3b+TWJRL+WkNKffoD1S5FLOg
         megw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767272952; x=1767877752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nzS+Hy30FELScvyGLAQhm0QHElXtHjtPJGwOfXP5M0s=;
        b=G40gyXXWOmSYNVbnepx4YQ6VJ8xs9tNwh+AvgQN8UA61b5E3/brP2DFhB1FYfGldWz
         V8uK0ahTBg7kXxyo3Z6YTsUhF+D5flYLBhsRiA6vI06/TNZLc7ZRg+eg8hs8RrujCu+X
         qMdRD/yuIqx/hS8Bgsve8npNlHSgs8h/jUt+tCJBypuwY2e6bmgCN8eM4je0iDRAgB1F
         VbFsXHOZGlmRf5zPb2EdNpsPMau7ZSzNT35CmmTlZlJuTqMiBsufivBsxtW6sIQidfZ+
         VrziJkViHwhwt7Uiat9ibi/UnS0qYHS3S0QSBxX9WU0OC0CKKsPcxB7euS/syQovRfbc
         axdg==
X-Forwarded-Encrypted: i=1; AJvYcCWT/Mg5XhoteJau6hyhxIz77DBoCkmrZ7Din/muapu/T3jLR+ImpeuvOkA1sJXHSqjHdirTnqquCw==@kvack.org
X-Gm-Message-State: AOJu0YwULAl7FAw1U8MjogkYlTjZotdGTW9LjPnt/MlCyM893aM0vKXW
	fPOxsrC3GVK0Tmt3vc+VQZXPvQVHzfhMcDxFbZhWqwjm2UnF01ME75tt
X-Gm-Gg: AY/fxX6Q83E22zM9VOzOE2gnEZK5EMUc4trC6imlLozubEzfdV/L9TqYxDVolExV2TN
	G9vUbSgR26A72gYwl369LXXkURMaZSfGTZq2CMGpT70PozhoWOT2E4EbqF1d/p4qvRs9fDKNEMF
	XRTZSXtqNSlWBMk4Jb407g8SSNf3NV1arZ15SkvSdqw9+oMTo2zVp4P4ym2Up9lC6oy4CyZtNGH
	qRYVwah3qQWMJYqLAkydQ719vAypcCQxy0yy3rvU3Ke+yp0X44vi+rP+R2r8vFK3GByIJZwb+g6
	BodAaSBCRArmGr9xys6YB3koW56fc1mJCvu0ca4SphMFmxOfJemrDSMqIkuq9o3W4NqVafw3NwE
	kJUMaBZjH5fH1ZUoFyM7YmefMaP+pZZOHbUotl8Dfsact4iUjioAvoCbTGp5nB8G2H+/NIcx8vj
	qfu6tJQoc5yv4rGhxpP4XrUPXNN+Xb47DGC3ZjaAsPOUuiZAeT
X-Google-Smtp-Source: AGHT+IFyKM4HrPlnSDkCxENTLwE2h5QfTHvvznDHmte+JFg7pvwa2rlXh6qxgJYoi3FRxN9WYb4ESA==
X-Received: by 2002:a17:902:e552:b0:2a0:8360:3a74 with SMTP id d9443c01a7336-2a2f2835cfdmr281796915ad.51.1767272951863;
        Thu, 01 Jan 2026 05:09:11 -0800 (PST)
Received: from name2965-Precision-7820-Tower.. ([121.185.186.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d5f5dasm345652335ad.82.2026.01.01.05.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jan 2026 05:09:11 -0800 (PST)
From: Jeongjun Park <aha310510@gmail.com>
To: harry.yoo@oracle.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	jannh@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	vbabka@suse.cz
Subject: Re: [syzbot] [mm?] WARNING in folio_remove_rmap_ptes
Date: Thu,  1 Jan 2026 22:09:06 +0900
Message-Id: <20260101130906.839504-1-aha310510@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <aVTJt9M-A1BL8w5O@hyeyoo>
References: <aVTJt9M-A1BL8w5O@hyeyoo>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 369EF1C0011
X-Stat-Signature: mzww4x6t41dg6e59149mc14j4hn8e99c
X-Rspam-User: 
X-HE-Tag: 1767272952-730341
X-HE-Meta: U2FsdGVkX19Fy0rv+HVZtqA1t0niak7i5Wlays1WS3fVOq0lN1g0w95s1zJsbbZbHT5rfplsn+XZWe37N0MEUIDeRI9YwqIe94kwPS3OiOEK6cGtHFBMV04t6ehBTPkxH4M60Hpj/L0jv046cGODldAOz6zXtFanR7EgIkxgZZuvBJCJgqkFnUF7T3+iq9GxVVALzQo9tGKWdCQilpBAhJqAtapKKNtOkmadfV+7cWSe1s33wJD263u7FiaCVeQEWG+75wqJT5OwH5zxbp0GuIoyTi59YTfLEXRRbLXxOU6HhR0E41v/DmO12Rxbrs8IIlv5xRUaND0uvR2/EXe6Pbkf01BP0yYhgkRGuvSlNiIKy8BwJOdZl8z/idIRAssseF3bABi8Ky9msh9+Lrd/bPLf9+JUPsiiaTIN2CyX0f61QEJUxspcyJI7gzsU8DiZBrTI2KbALjJsvbRPSLQKUlpIgW71gSHOqJTldzfqyrIuOzGkXb7d6x8J5hL9UhVBpj6EsDhNQbpnNEMgYKLVZzm7xpuusLKRG8FgkqmY0hKbqPyUVfirKfeP9bjFmBAyWqciMuYKbf1UDhZOlBYHV4rFe3wtrBfcaM5xFPrcQ5qh6eWPX/aHWar8uUbTo9KNCT5O5tpFUFYVxaR2x6ZgCwB5GIVIrLFgbV2QuKCavvbo0DyIbsVM5jRFKChPQSd9qi0gc20+b6MMyYXMVSYIvxAggAwEuRxSlyXpGLXQ8p4pIAfOeW7Y3r3xZWNJE7JYNK+KkhxpxmFd0QK67nr09KCVUX6kgJKMNQwgZzSw3TKzs7uLiIOJRgVzs4zSCP0AY82nEvae7lGsvJbgkDszK943YpRYlGKU1mkWqPhmL1drHtqSUOC39jJpYNIIVOXJAA1UeVbllJnW0T05qy7A0kLxITyLelSAiZOLNwnLDzC9zABwFfBwVTaGIVABqczMcylDh+Jzzdx3seLluGX
 PGBbKtmM
 JDP/b863hu+EXhfwKPiT3LKFQqsGG+pj76a5kN3u7rie7RvXbEW9dLoJsSgMxQqfISey9nlJQ4HMP3GaGyZmnHFYN7nzzl/YReZqC8C5pV90HyMsZnBSK2+Leh+liGO1VkG7Y7jkrYnYF6N4hnN0DYZ1rMLpVIPR/0hpQMEtgM0H/IjuKOVgt8WSPw0pVx3oBrOni/WbVdFV2wOYFJeji6PAIsrkXTfD5AkQ8Pz26u4i0RSI+N8P/MY5LdmIstkZMG7ufY27SS3KyrQrUob1kONtTFPPMiL7zJAR5HNgaJEeBfLMj/0Wh2EZRsfs6oia/2Lo1DrLKdGpS3ymVhuthcnNulY/E4veyG+/+w11iDtKMA9Q9bNAX7l8wc9EVqp0vWmv2/0WSz07JvLobcGs4WtZXN6PsSwhLBn/KJ/Q2Hv5o+qSMkeu8sHzC5m13qkbMyKmjW8S858ja8yZmLd0nQQCY7qaIhEumSeWGgU+Z/D2zsyplhzX/XS0nHFYmKRLKnwepWjR8fjtyG5F2mOo6yfltWW33BPVzMsUdMNau0eI4cI2zaygkbuCS1hzsUkav55FChcF1sYp+k/I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry Yoo wrote:
> On Tue, Dec 30, 2025 at 11:02:18PM +0100, David Hildenbrand (Red Hat) wrote:
> > On 12/24/25 06:35, Harry Yoo wrote:
> > > On Mon, Dec 22, 2025 at 09:23:17PM -0800, syzbot wrote:
> > > Perhaps we want yet another DEBUG_VM feature to record when it's been
> > > dropped to zero and report it in the sanity check, or... imagine harder
> > > how a file VMA that has anon_vma involving CoW / GUP / migration /
> > > reclamation could somehow drop the refcount to zero?
> > > 
> > > Sounds fun ;)
> > > 
> > 
> > Can we bisect the issue given that we have a reproducer?
> 
> Unfortunately I could not reproduce the issue with the C reproducer,
> even with the provided kernel config. Maybe it's a race condition and
> I didn't wait long enough...
> 
> > This only popped up just now, so I would assume it's actually something that
> > went into this release that makes it trigger.
> 
> I was assuming the bug has been there even before the addition of
> VM_WARN_ON_ONCE(), as the commit a222439e1e27 ("mm/rmap: add anon_vma
> lifetime debug check") says:
> > There have been syzkaller reports a few months ago[1][2] of UAF in rmap
> > walks that seems to indicate that there can be pages with elevated
> > mapcount whose anon_vma has already been freed, but I think we never
> > figured out what the cause is; and syzkaller only hit these UAFs when
> > memory pressure randomly caused reclaim to rmap-walk the affected pages,
> > so it of course didn't manage to create a reproducer.
> > 
> > Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous folios
> > to hopefully catch such issues more reliably.
>

I tested this myself and found that the bug is caused by commit
d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs").

This commit doesn't mention anything about MREMAP_DONTUNMAP. Is it really
acceptable for MREMAP_DONTUNMAP, which maintains old_address and aliases
new_address, to use move-only fastpath?

If MREMAP_DONTUNMAP can also use fastpath, I think a sophisticated
refactoring of remap_move is needed to manage anon_vma/rmap lifetimes.
Otherwise, adding simple flag check logic to vrm_move_only() is likely
necessary.

What are your thoughts?

> -- 
> Cheers,
> Harry / Hyeonggon

Regards,
Jeongjun Park


