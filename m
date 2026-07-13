Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F6DBC44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 19:43:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82E936B008C; Mon, 13 Jul 2026 15:43:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8146B0092; Mon, 13 Jul 2026 15:43:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67FBC6B0093; Mon, 13 Jul 2026 15:43:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6396B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:43:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B21E8013F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:43:27 +0000 (UTC)
X-FDA: 84984777654.12.56F9BFC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2794540009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:43:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aBDIKZHa;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783971805;
	b=g7wS6ICYkGCvN3BKGn09PMoa2d6A3fZcN2o87mTUN7XQ8eFjPwVgvDji9RqHQS/KS/o+lT
	BukdJ84flgI+BSQE0wJYAht18Wh6oXwaM0l9OpViuZzSkKFsiOjnTYjKHfWvfIr3mXKmld
	gIlPvySBkaX0wYcKjr7Et9rO6WPpq4U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aBDIKZHa;
	spf=pass (imf01.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783971805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oh/99NzF4tGS13cUL+eRJ8P8DrHZhD3bwsodlnkuIoc=;
	b=jCw/RbS7TwFYNHv5fjrpUuNFWR4knnJ5mExo8KuKaqbU+CX4XBBWQw30QVc6imWjKsA0FR
	lDhLOjrXXzYP/GdDUVqT6SXuzdGeZzaye1FtE/vS8TtCY1G5ezScXodmcsdnnodsdsLeQy
	dFfmeGkA5d8xxInRBHgA0JiZrIr+U1s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783971804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oh/99NzF4tGS13cUL+eRJ8P8DrHZhD3bwsodlnkuIoc=;
	b=aBDIKZHalXNWNIhdnnQfIgIyO1jRKG8xv+eESO+WctxpnLo8Hydv0enVwOmE3BsJ2OJoIo
	WF+PxwTHzEvuk611pV7FY+T42LibMzt+1s8lsz2lBHilpOjOGOxA/L0rwzDNHuBO+FdN3L
	VKw9nzmVChNNvNLKTdQBUbwUP2On9XU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-MGPiAJ86PvOaj1Kh0EYG8g-1; Mon, 13 Jul 2026 15:43:23 -0400
X-MC-Unique: MGPiAJ86PvOaj1Kh0EYG8g-1
X-Mimecast-MFC-AGG-ID: MGPiAJ86PvOaj1Kh0EYG8g_1783971802
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-472a798fc7cso116292f8f.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:43:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783971802; x=1784576602;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Oh/99NzF4tGS13cUL+eRJ8P8DrHZhD3bwsodlnkuIoc=;
        b=FaaOU3U1xJAc4BiIfX2IWSxcUSjL9WlKh1MQoaVlFuR5H67w6ULWLUBiaMvnBQQCwJ
         Bn5iNCTYRTtl7zf4ybPaoi5WYJ0BB+uegkMt1hHucUZBI60tylWD5CStEngo2iJA0d9z
         IUS2xcYpgULMTbw5zrwOKAKpPMhbzFq2ZWt9EPmSBso1p8n3ELgtYNUp8wQryb5l5xI4
         cbSylB5TKHJI4lKU1JVXnnS10d1GlCr5s5MJAcSNHx7hr1tFFgeTK5EuTUzfKLmN4P0y
         u2SjEPUrFiVairOxQNa46WotAp+l2G272M8B/bhc1v9sP6SjKUi2xtu/4xSYo/xv2k5a
         zZ6A==
X-Forwarded-Encrypted: i=1; AHgh+RrM2zSDSA04KTprdpsC6c/ihYnG+FwkB6ROLhpfsLADFhSlcTwKERS4koCktE/IlvMusHPpec2rFw==@kvack.org
X-Gm-Message-State: AOJu0Yyi4JNX26N7gX+ikyHPn06CGdyhwmuSuGfo+pvplzptr3kQGbmx
	lMxJa+fwBCbBfcTa3nYyopcjsggppqAaWT+EkubP1CbxnrXLdSahGn5u4+o6aeluvckwias0YZg
	w8k82TeYad3O4AG6Ffd3+4HofCZqafrnyvwbWmDoELQwGGh3SpY9q
X-Gm-Gg: AfdE7ckwpdzMLIxj/TTN2JFwxiB/aFGTBbEHUQzNGFtNSnRlJQ+JX+EiIXCP0Lb/gHZ
	9ukhyZJc347LQk2C+/T+cn2cjj/IyHQATbawFOY/JR31fK0hpWkkW6pPr6z9sfa1fdpFbOJX915
	PR93Zb387+MMnbA2thgGiP5uXzsMtqlgcV2PXyI2ohX01utFN7rI3abiGnozorURT6JxOmwJwBO
	FFy0YZN+FPbXhRDT2vRWZ9R+d7BKS9iLKDeAUHCLQRHCGzuHRW+Sv3v6CJCskRQ1iHADFyrxUa2
	Rs6rn/Y73AkPVijiuTFoDYz8FTrvvTk4i4R/tthogljD97zO0UgNeSQrZXJSEQUYE764Nv1lfpc
	yB3mHh4VYLMtD1EyKyeqP7ldpFVqhhT9pr4s=
X-Received: by 2002:a05:6000:1841:b0:473:823:1924 with SMTP id ffacd0b85a97d-47f2dcd7860mr13165055f8f.39.1783971801736;
        Mon, 13 Jul 2026 12:43:21 -0700 (PDT)
X-Received: by 2002:a05:6000:1841:b0:473:823:1924 with SMTP id ffacd0b85a97d-47f2dcd7860mr13165028f8f.39.1783971801248;
        Mon, 13 Jul 2026 12:43:21 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-24-117.inter.net.il. [80.230.24.117])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4634e0e4sm1936476f8f.4.2026.07.13.12.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 12:43:20 -0700 (PDT)
Date: Mon, 13 Jul 2026 15:43:17 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Link Lin <linkl@google.com>, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, prasin@google.com, duenwen@google.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	Ammar Faizi <ammarfaizi2@openresty.com>, jiaqiyan@google.com,
	ahwilkins@google.com, Greg Thelen <gthelen@google.com>,
	Alexander Duyck <alexander.duyck@gmail.com>, stable@vger.kernel.org
Subject: Re: [RFC] virtio_balloon: fix Use-After-Free in page reporting
 during PM freeze
Message-ID: <20260713154243-mutt-send-email-mst@kernel.org>
References: <20260709224330.946683-1-linkl@google.com>
 <20260709161253.6b5e9ba349f70a3ebfb8180f@linux-foundation.org>
 <CALUx4KQ=bYTpDoDAZ+iVb7Ehaa0LmyPDsEWk3xFFmTVYKrpAUA@mail.gmail.com>
 <59e3dae7-a203-2e1d-3b65-875b7e0e122b@google.com>
MIME-Version: 1.0
In-Reply-To: <59e3dae7-a203-2e1d-3b65-875b7e0e122b@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BebpmClBrMY4K-NAQq3NyuLyhdnbnvzwYq3JD-nOXV8_1783971802
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2794540009
X-Stat-Signature: m1zmxo3jd7f9b7m194ba5ctp1ksn81tk
X-HE-Tag: 1783971804-766464
X-HE-Meta: U2FsdGVkX1/C0tLdXLMRwXMJN7ylk9R4Ie+kg/Y265x0wfc/TeiJ41RHwB2mVQu7/aZgbTtKiE8vLO+wTaI8Qj+0BAc/QpSJ9TuMfppFb7XISslX5Amd82i0UIl9+/pCpPnKO5a0fe9VAUSEytFHMjIL2XHSM7NkwygR4WS1zdsUnS5apfw/u38egoYw0u8VKcPneUw/CVgIIo9jkGJ5CKYP9BDLO9V6kAEDowkglFaM1OZkhKK9HClKaLIzI+I5pJD9zOFcBeC6DpXAvdFatcNmFqzkpWs4lUcl+cmnmu6YHNOrznY30z1ChDqI/dhZBDTdlMvHN6U58SEKmb5OsFU6oxwEccANXvAR58Qj5biPhQ+gegoJ8Smkh3Jrn1tMw2DVUFmcSwoufD+QBRhHWrDttSs6QHOOQSDDvsrpUobBKvHBdVljHdDdXEoVmlRcwaef2Kk2OygAGBuBuFVislb0EUjMYNvUpD5BFgtERjOhQslLDHuzHTx/EHAL9yrUH3Psc3xaA8EJxUuRgFcCjlYihJ+rjqeRTgQgk2FQlX+Zkh0ZaY/os5eCtCSx5YptLpCnCmbUs8V4bE5tyvKS7l+BTLfM+rurDSlWbqDg0Q8olmx5sxdE73cpzkfhww5V1uJJcDD0N5eiL2TgrlU+6DH0YGu6kx9/G1tgp5C5TUBz/xgNi1u6VvqG66ZhakUMoX/TRtSbvaIUtsaChUhe4uiLQrpRpSaZO+xQ0auSpEvSyQuZJdroXCAsUnDKfVzVi3I8ERsUb+yxyl2lV4CXT9UCCKd2tOzW3OVlQ9eXC3kTXYH6RdQVWQM6Fjqnc8K/wkSGZPtBSsYKK02rQipO5Ig1/n+42yXTuDSA0uT9ijpOeuMVto9vlisRnjNpmuGW89ty91zwUTC1Dcz+KPJ315TmtACBSKft3+egM/cBmKaYGgPMo/Li2accMfBCe5nAg6i+SIfoencHCoNZQGZ
 mvibJV22
 tDGoBWbE3HYXwz/LDjhGQdutYxt49BE2e2xN1iRwGHgbsL6Bu03zF6ofoz05759kw0lEOWCFN8EFTdvaM3V1ugxcRSbfgiWLvXfK5xEtlEqDmBF22hSChFp1h0ppSUdeL0d6wJA3d6IhyKxuRivEcp+pmnghyDlY78sOYdj3NL6ucwkY44XS+CuT1Ffq7O2PIX5ht7oC7QdXzjtjQZWIVMAoJlxZ/Zplk1MeugDYKjI6eYyet0sN3uN/UxVD6dJnH/hQJc+yE4hS1ACisH668mKAZVLgJrD4ViIgh+SsQjzjqhZn0x3J2HFo2qK7fambS4FzS9IXoxNBZ31LlevrbPXsyF50Bomm+QAREbZRW+1gmoFiUiOqloX1rgOgE8K0AfELx6J6eZ8fHkXJjvHh61aqNxUjE1/D6RBg5496o/8QNgL+Nu8tUMk66KoP3POP0Hp1bZuvBbaBs5b9tl/hGXVvo/ZXL6Rdh92R2+9/hswXRNDX7Pv6bK0syXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 12:41:07PM -0700, David Rientjes wrote:
> On Thu, 9 Jul 2026, Link Lin wrote:
> 
> > > > Fix this by:
> > > > 1. Unregistering page reporting in virtballoon_freeze() prior to calling
> > > >    remove_common(). This clears the RCU pr_dev_info pointer and flushes/
> > > >    cancels prdev->work on system_wq via cancel_delayed_work_sync().
> > > > 2. Re-registering page reporting in virtballoon_restore() after the
> > > >    virtqueues are re-initialized and virtio_device_ready() has been called.
> > > > 3. Unwinding virtqueue initialization via remove_common() in
> > > >    virtballoon_restore() if page_reporting_register() fails.
> > >
> > > AI review thinks the patch didn't do the above:
> > >         https://sashiko.dev/#/patchset/20260709224330.946683-1-linkl@google.com
> > 
> > The AI reviewer might not have parsed the entirety of the fix I proposed.
> > The patch submitted definitely includes the changes to virtballoon_restore()
> > for steps 2 and 3 (re-registering page reporting and unwinding init_vqs
> > on failure). It seems the AI failed to parse the diff correctly. See:
> > 
> > +       if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_REPORTING)) {
> > +               ret = page_reporting_register(&vb->pr_dev_info);
> > +               if (ret)
> > +                       goto out_remove_vqs;
> > +       }
> > +
> >         if (towards_target(vb))
> >                 virtballoon_changed(vdev);
> >         update_balloon_size(vb);
> >         return 0;
> > +
> > +out_remove_vqs:
> > +       remove_common(vb);
> > +       return ret;
> >  }
> > 
> > > It also might have found a couple of pre-existing bugs in there.
> > 
> > Indeed. Regarding the first pre-existing bug found by the AI (leaving the
> > OOM notifier registered during suspend, leading to a UAF if memory pressure
> > spikes during S4 hibernation):
> > 
> > I actually addressed this in the commit message:
> > 
> >   "(Note: The OOM Notifier and Shrinker/Free Page Hinting features suffer
> >   from an identical lifecycle flaw and are also vulnerable to UAFs during
> >   S4 hibernation when memory pressure spikes. This patch focuses on Free
> >   Page Reporting, which runs periodically, to ensure clean backports to
> >   stable kernels)."
> > 
> > Regarding the second pre-existing bug the AI flagged (leaving uncancelled
> > works on system_freezable_wq if virtballoon_restore fails on the cold path):
> > the AI is correct that this asynchronous work cancellation failure exists.
> > 
> > Since these are separate, pre-existing lifecycle bugs, would you prefer I
> > roll fixes for the OOM notifier, shrinker/free page hinting, and work
> > cancellations into a v2 of this patch, or submit them as a separate patch
> > series to keep the stable backports clean?
> > 
> 
> I think it would be best to have separate patches for each fix; Andrew, 
> please correct me if you'd prefer one patch to address everything.

It does not matter much but yes separate ones are a bit better if
each can be applied independently.


