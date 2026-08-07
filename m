Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A5AAC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 00:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 164536B007B; Thu,  6 Aug 2026 20:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE556B0088; Thu,  6 Aug 2026 20:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED32E6B008A; Thu,  6 Aug 2026 20:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A02986B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:38:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5B4F12027A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:38:12 +0000 (UTC)
X-FDA: 85072611624.27.2C376AD
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 158FFA000E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 00:38:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HswnDeBg;
	spf=pass (imf15.hostedemail.com: domain of linkl@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786063091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MRJZIG7PpGC8GI3G9OdkHZpvyVmLP1ZrEzMgLyM7g80=;
	b=sdow+/0ZT+WjlnvELIMEz4ks0rOIsuD9YjQ3SKO3w+0d8GWEO6gnv+ry5QzImxbtlrbkCP
	luvXkCJsIu6KAlwqLgeATcrJvbebFcKICL0am4Ki/mk71ytXAI8uQzK4fLJw9ToLVdVWF3
	7OAMuqh/tHgF2Dsxc4ogUrgsjOqTmSk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786063091;
	b=xyz+p1YRIUTUSKMjEjw7VOqSw/PfDA4LV+rGjwhFAY5R0jyd3+z7UtQE8ip3GYCSbg2em8
	hW3fn9F15vTt1CjTr9buKYbmEnYjBO8+jmRcTNNtswVEOvlOTCIToEZuH9QG28CdzrQwsR
	nvU1ECDijyIK68Pth8TaEqRkcryZZ6M=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HswnDeBg;
	spf=pass (imf15.hostedemail.com: domain of linkl@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=linkl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c01c79467so111901cf.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 17:38:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786063090; cv=none;
        d=google.com; s=arc-20260327;
        b=BxqAXpWqiQAjKeUjzMV1US6E8bOFhtYEQJ+gMfz58mQblT6ZJjMCPYOQaQ56K0+jxM
         oVdgaSfyRoTCHEjyznA0WcKW1abvlgSKk9QKjmSoTlTwDiesnBIkHTRM/XeEu/YpnqZn
         N5/djEQN8nzdCsbJghXISe+yaAEv7u7cB4v0oHavxJ/A9I8sH2qKnS5cA3Tp+bkUFP+E
         EyqX7qxLS3d2hDwpBvTaqPvxHamgZW1EUfFoMub5FVWgZBcdMzxcpPMQb0CzropRotiu
         wI0VDny3J95gNtKu94TPu/V38tRaKrF3GqzD5M/t7um0p1fr2VBDdJLr85VUYRwPM6io
         jnDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=MRJZIG7PpGC8GI3G9OdkHZpvyVmLP1ZrEzMgLyM7g80=;
        fh=Pjz6JhPZ7EXAi4V2e64AVEYGkWnFasXPiQzOHPKzdcQ=;
        b=Hb71Xpg2KcWzaALSDOVAUBJQcShzV/m4TI2zRtRnKZyXs77tvVhTz1mgGB7Z5r+PDj
         /bD75h0MTJBhdHFdhJits/JSVI+/QMX7lXWUmncgDKYzfBywdFdVl0L6IzYaEvWm4Ays
         ewHmjaNUQTjwoS2AuEv0eL245ISO672yxWaMb9uecVs7BClonowl5y7CP1GvyL540BAK
         CybgloTcLPd1KnExplq+lBaJPni+b8uoMt27V9nZLD04jBLQ1nDezfGggov51NjA6otW
         SshjFmw0xJPPcNgTr8mZansjEKoql06UHkwP+T86wBvSnbdzt1KvEMrw/fK7jxVZDFIo
         mAsg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786063090; x=1786667890; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MRJZIG7PpGC8GI3G9OdkHZpvyVmLP1ZrEzMgLyM7g80=;
        b=HswnDeBg0GZ/iE1RmAvs52LQ/o0QyNQ+WuVIPiiFJ/W+hbRva+Ln1c5O68ndkZK2n0
         fJ5kV9VOrVjUsHMeJVYGyIUKIF5VMLqSULwqVhebI/D4FqUtYBcAXJJtuPvzqH0M1UCY
         p0wfOwujZCeN4tsgNda3275sZnOmmrAWPovswtukpjpAPROprmJUCQQ8qKpoAJWB2Lo0
         qEzK/kp9e5kjM4wHhNeOXMtlzcF3JIPRlv+pbnbH8VzGWeYdF5Kt258ueUDw1/mi1bnz
         KHr1ycfgoH7d/NhjvNH6xp2tb+pOiUg/Us9cH/pKyBQjBby62LC1by+nsdhyqNiWQSDU
         HNzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786063090; x=1786667890;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MRJZIG7PpGC8GI3G9OdkHZpvyVmLP1ZrEzMgLyM7g80=;
        b=Armp1xJ95RLkTE0SoPeli0djrxnayzkezmKxrzjwLW8bgbBBp/Eo7RhpCFyQVHaLhu
         GSyeJnMPcosjmMx2sGIJjVfWO7nF29Rr0j0Vo76Q6gUK0hhnTX2yOt9r+rvHhX3mO486
         PLKWJxJJMPuoPaGz4YGaHOxbDr6vSMHY+OOsEpCFCR28ZxmnFqNb+758z3LVJh7Vgx/l
         XIIDJy8rQIUltXZaELkzOp2DTnUxKypUSCoio44q+MNTB0ouOuNfGdl63Q5HtEPcFnsH
         aryRMKXxtH83K8Q6U4KSAkzweesxmcbIs/mGdJbc3POImxIRNpLIJIQ6MMrGpbt3DiPl
         YIJA==
X-Forwarded-Encrypted: i=1; AHgh+RoI9j4JAMZpOZ9Bd/yhKrp6idWhsxM6hxH6i6CpdY3snHmEXHGVLdZeNE86nX7UhmhPa+IXLEPS8A==@kvack.org
X-Gm-Message-State: AOJu0YyVJPbapGVbx19V1XeHZU5UaDQsynPOEUfVayqLX7XcdGguTyvD
	xgiUTZJYOY4OeSOdrbS6YkvXIFvaHp8NHDfImfZnt4qpzPRUx+GUdU5DRJlQwc+uQzeKE+uPnqK
	N1YAeGRtbulStvDA73nIcImmNxkOhEJwSwhn4Zw1m
X-Gm-Gg: AR+sD13OCO+d77uHHNl/XTBvVojY65d4zq0gT2Ebvw5hVq1OZbaeOFHKSOEPeWJuWaX
	PGkeXpeThUG7GOknHJj2q/FA6S3NvEyCSdwgZE1pF/rUEhYKwfNII4F5gc3UW5BzWBwQD+3qNde
	/s5Wo/RjlQ05YrSZwuWzS7UmNZ4yYFJAxAChkaQog2H2XlCpilk++SNK5xvKCcqpTX3dKVOb+BC
	FW/IeHWVapUosZLs0uCtzk40kMYQURn+5yIteMpLdCFUAnW0AjqfkynmLTydo/GNtuM57kWj8S6
	MaJ19QFTDjsg2n1SWVEgH9CHRPv8dIA4bY1a8FV04MGFKysyCTFD8gBPsEHk965WlYERlwL8gkL
	65JSOIKfjeoc=
X-Received: by 2002:ac8:5893:0:b0:51c:104c:100c with SMTP id
 d75a77b69052e-52d106def12mr7006611cf.2.1786063089410; Thu, 06 Aug 2026
 17:38:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260724014605.3377283-1-linkl@google.com> <20260806185414-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260806185414-mutt-send-email-mst@kernel.org>
From: Link Lin <linkl@google.com>
Date: Thu, 6 Aug 2026 17:37:56 -0700
X-Gm-Features: AUfX_mzsCL5eLjoVeX8KOZ2z_HBCF8ziBwe-qf9RCI-8JSE_RZaQA3PJ8CCVsKw
Message-ID: <CALUx4KSGtvswSARWZ9L8rbWsPmSorHaonaSWMT5UvQX9SQSqFA@mail.gmail.com>
Subject: Re: [RFC PATCH] virtio_balloon: add VIRTIO_BALLOON_F_REPORTING_PM_SAFE
 feature bit
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, virtualization@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, prasin@google.com, rientjes@google.com, 
	duenwen@google.com, jiaqiyan@google.com, ahwilkins@google.com, 
	Greg Thelen <gthelen@google.com>, Alexander Duyck <alexander.duyck@gmail.com>, jthoughton@google.com, 
	stable@vger.kernel.org, Cory Maccarrone <maccarro@google.com>, 
	Taylor Scanlon <tayy@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 158FFA000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: mxywdu8uhb9eyg6r6xi4tbjgffoh83u6
X-HE-Tag: 1786063090-287406
X-HE-Meta: U2FsdGVkX18AWac8Uogi2KgC0QAlYtEiHwgAwJNqbf3JEwPFQzUt56rV7Le0kXsmVtNZvCcb59LCThER8sEiO8BTiz37bFtpl2IgB+lF7XBP3mOXzauAuDP7bVYnnIAiuobKTYuFHveR9yUVbrbp3/qTKklN1w7hcOHuYYOfNr4/ts/K/IncQyztKdfRAI4WgwugOyxEz2H43aMGUYlv3Mku76fYa/d6BXe4SL8CLzG+VHc72BpdZwjk3XFdmmU8SdI4wHjzK7KrwGjC2GiNs2WfzGe2wKFxZBdfoGe7Z2Nx/k2uMAQJpxVeZ3kGKdnSvYx2s9A+VGACCg2RWGgTu47INaKztdIDpioJC4z4tvYCoJC2FUzW6xmCCgeZywtPrL2xLtyh61Xlgov4O/2nfIRuQXK98NhUWBV7kvGKf8IUv6puR7PAr52UNFKloE5BAn8W+oSQOSJxFbv/9ziKPsvxKb312Mjh32Tqil+fvFVsrjmaX+wK2a3CxV6IHeuvidutWaVC5RoVfTsIuiXoyoSJ+OF2eW11wHJCcRsVtj/2aWDRK/scjmQeaH4yNtVqvp2Y+tPTuEr71wp2S9j+Tde9vNkqmiXwIeIWdB1N7wEoOkZGMJ5ucXJwW2MViypWcOPXVOmww9I+WLlRflOWbxMU4c2ovAt6se5J3bQvsjB/H3m12U5oHoVhWH4qQPg92AtGtVixpLDmr1ocZ7ot1A0b+zkMuNoOvsCa8pxaRWliRjpdhKEmE7E5W2ythrU+ovr/LbOkyg00wRIKtRkRCcf+TXZMPKv00vgrmoqQ5pfgMp35va/MTsQYDFsSca8ClIWseHDEZvob1ByUeK3/ZhQyvPKDRmE4Z1kpvCEKd5W6B7n9wWrRdXkYWjMHt8EMfXUpup1nGWz7Ccm0grOcH7LwtAolCi2CxOTHFyn4hm6gln9AyRilSoz1ggBZ9LAfAVjX4N6dtIAXSbjusMp
 B5T4iqPr
 uAxdHrWutG1g2iCJ62WKZ+nrnJhYAx3sScHTAn8NmRPQqhVPyDjjRAx2PqNy6UTtCbKep/m/WdtjG5s19mh/nOjB2grYQvrCwt4y6COWgd2JXnNwNsC4s7IJS3VofcFOcgUJ+GxojeeS8W4dd3sUicT7D66wampWp1vJzDj60GOyPlyjxcGT80mQvhYFgMTKubd6+gsbdVjwN+dsIgWNMTVXDRVd6bGNj4wnla6vUdBQvbkdgMN78Oz54ur5sT9FSmGatlETq0HddOy94PowuFtPZWCD1pPOS5qQ6M0jIQVZD9EHx1NdJWOTQB4/PiUOJH+7AYgHomAZMhpUVr/z5PJKxGZ9A0V1Mh/u6RzjuY5DBzdqf4h+2IFacyx9tHdDIeR7X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 4:00 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> This makes no sense to me. So there's a bug in the guest and it crashes.
> Patch the guest.
>
> There's just no chance we'll add flags every time some guest drivers
> on some OSes have a UAF.
>
> What makes this specific bug special?
>
> Trust me when I say UAF issues e.g. around hotplug are a dime a dozen.
> Now what, let's add another one around hotplug? And so on.

Hi Michael,

Thanks for the candid feedback. I completely agree that adding feature
bits to the virtio specification to paper over guest OS bugs sets a bad
precedent, and we will drop this RFC.

To answer your question on why this felt special from our side: in public
cloud fleets with unmanaged customer images (BYOS), we cannot patch the
guest kernel. If the hypervisor turns on VIRTIO_BALLOON_F_REPORTING globally
for memory reclamation, unpatched guest kernels negotiate it blindly and
subsequently crash upon PM suspend. That makes a host-side feature rollout
act as a latent crash trigger for older guests.

We understand your point that the spec is not the place for driver bug
workarounds. We will handle this compatibility gating out-of-band in the
hypervisor / management layer instead.

Thanks for your time and review.

Sincerely,
Link

