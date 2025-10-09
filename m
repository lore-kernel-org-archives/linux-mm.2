Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 812D1CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 18:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0C38E0016; Thu,  9 Oct 2025 14:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C888C8E0002; Thu,  9 Oct 2025 14:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9E848E0016; Thu,  9 Oct 2025 14:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A8BC68E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 14:47:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 623C1BCDB0
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:47:46 +0000 (UTC)
X-FDA: 83979459732.05.9A430B8
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 717D040004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 18:47:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AM8kY9le;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760035664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZuz8JrVqo5e+MsWYBkw7+610nun3cMbHCKwMsKJZxA=;
	b=QOSsQBWBWOpHAfmb7T2uilLwOx8McuKlOncvRBKWYGP0PrlLFjf10S1BeCyI7fEoCgESmB
	++JwXmCbMaJQj/ZfNOhWDUauqzaS7iHaHiIFiyFvWm7QBGa6wsMck5JvJ2fWCBjDPsWrbD
	4bOKmfbo1UaAJH5UDvVGiEHYDEWNs5I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AM8kY9le;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760035664; a=rsa-sha256;
	cv=none;
	b=YWA6gbZ1KXGoWnFA0eJOcwOc0rsvn0z4YQ+mNNXmTHAa1iCCNdd6ZJhwzrGcwhMbzJFy9o
	b2nuFL274YwetvP8J3jGaIx3LthaErTzu58XqQnZejajz6+P5IFUGKxfd2/tgKCyLBm5xV
	4nyvGwuT38my1PGsIqf4pkuStUsolwA=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e6674caa5so7431215e9.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 11:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760035663; x=1760640463; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VZuz8JrVqo5e+MsWYBkw7+610nun3cMbHCKwMsKJZxA=;
        b=AM8kY9lezgf/5RyN6SvaOBjVEi19o/WZdn7Iy/pThPaNfr1eP8acx2uuPFPadgRcIC
         xMFATKqJz4Lcw++Pl0/adXE6+OzLcEzO0qV5NxOIU2bxHuZVKSBYe0wsjI4ltGKcvCmJ
         y6/LJwhJO/jBDYWQ9TAigadNFT5vd/1OuBnDS0OnvatUNBEVk66EkZycH40qfBiU3w+8
         30kjbbJ1rt2q1cZILWX0q4iWNiza5hxDTSHrUTZ9dM7TQNzIhBZr2rSpftM9ZYQxqyFm
         uvz6NGFvOzCAAW1hRqBS5Bxz7v2fpQI+iFHoDnaecVI/A56zXBtnlM7bj68ToBC8BbcD
         +jVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760035663; x=1760640463;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VZuz8JrVqo5e+MsWYBkw7+610nun3cMbHCKwMsKJZxA=;
        b=wWIErDMM87bEBgfeOcPWkktwaUWESJ3Wfx/3+/e98tfZ3pEbj3TzaJnXmkPydTSwRl
         yF2iAuJmyJVhDwFyRqu4PA3bNuD/xfGTUNwRR/89ARRovdg4sp14kYTRE7+uJEeaak0K
         tKIVmeGErJ1ja9DV6aVQTUGu32peSVY4EFRwyzpx2QsdLDkrYvmL86xVdu9c8qPCqunW
         VRdVS/N1ry2TBo6tYYWi8RqdlA+wVxHmL/IFugv3XI1OqdjcIOSIj1p2jc76wFnxbkEq
         x9cnWnUqAXWd9YtPlfcQeboc+acOQ/A7FjtVutjB2jAf8J1JW5TviP7zlcJdtq4eLGLG
         +z/w==
X-Forwarded-Encrypted: i=1; AJvYcCVJYGtlNHOOXP2+YRtzRAjXSl9/4z9AghcNqqu6veQCiY0ipDR4Slk5bJpsxuesXMGIR/DGxMx4EQ==@kvack.org
X-Gm-Message-State: AOJu0YybALlem/8qnfxk/hsvPLChET8qFcAzbkPpPU184EPs5lliQsN1
	QKTJw4THwXmcxnKwAaHOyHaWKxcfms0Gn05iYJsRkJ3Er47Sh9WppLnDpTTvWrkPoUg=
X-Gm-Gg: ASbGncth9+jSHcDhxKtTcRKP7AR02wGzU4+zx1RL2oaUloTfWDyP46U5kzUnw76ty67
	BPX01mB4AbmohNFT3b8bGEWdPd497fiwoDRbmrglxQEQZI+825RaTtJCFIlVXLm4huCdViWsADp
	u0Np3ou9uCi6LPll5BOQ+wGIDKuq1NVAbQR7FbzR+5SsspZsxxOFMu0levlfufZoE/SgCWEc9BS
	jKYhWHLtPZO5OD2m0BbAtIV3s2kSkXv1TMOH0Y5LXRdeaCVyyWeiBD0Ap4YGBnRK4LIGQy7ZSAa
	8XVp9K8HR4GGrRm8ZFLEsyrqdx/XmEoCa64MMHQw/USwvpL2BhVqxCVVhILXqWbWK/n9f8eaEXe
	HoY8n/JzqYX/iEaWHVnu60mtkdLHOt8V40sRtHQPrg8aFAVv1WL20PfQ/n+Ye
X-Google-Smtp-Source: AGHT+IH2XffCPdVW2wDSNYolrsEznFcKKrupYPDvnhkYrZPBJ7pYB+H9+xoQ8tpot3VyG+35KxzuQw==
X-Received: by 2002:a05:600c:8b74:b0:46e:37d5:dbed with SMTP id 5b1f17b1804b1-46fa9ebd3edmr60535505e9.12.1760035662797;
        Thu, 09 Oct 2025 11:47:42 -0700 (PDT)
Received: from localhost (109-81-95-234.rct.o2.cz. [109.81.95.234])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46fab36a773sm44576745e9.0.2025.10.09.11.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 11:47:42 -0700 (PDT)
Date: Thu, 9 Oct 2025 20:47:41 +0200
From: Michal Hocko <mhocko@suse.com>
To: Gregory Price <gourry@gourry.net>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	corbet@lwn.net, muchun.song@linux.dev, osalvador@suse.de,
	akpm@linux-foundation.org, hannes@cmpxchg.org, laoar.shao@gmail.com,
	brauner@kernel.org, mclapinski@google.com, joel.granados@kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
Message-ID: <aOgDTc-xix66RxXc@tiehlicka>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZ8PPWMchRN_t5-@tiehlicka>
 <271f9af4-695c-4aa5-9249-2d21ad3db76e@redhat.com>
 <aOaCAG6e5a7BDUxK@tiehlicka>
 <83e33641-8c42-4341-8e6e-5c75d00f93b9@redhat.com>
 <aOaR2gXBX_bOpG61@gourry-fedora-PF4VCD3F>
 <aOdSvriKRoCR5IUs@tiehlicka>
 <aOfU9YTKMPWzYOta@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOfU9YTKMPWzYOta@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: 717D040004
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tt6u6fbujh58yrzujcjh8cc9byp5sdnd
X-HE-Tag: 1760035664-42886
X-HE-Meta: U2FsdGVkX18eMw25fqPHGKGDo2MZPJtnraC5e+GceWWMFstWSM+LqBU5HzIa4DoG6nE298UdeQFSl3UaYMLeLlYUGm0U/2Owh2EJWEcNL33CWm+rMfcoxGL9aKRX2B2boa226L8EqrxAuCiPrHYhGsZ6ei8LZrgL/vmKJHMH+AR1iSXc+H8Gzk96yPGkBpFPP5dxt2qT5Ok0Aq94FUjxhGx90P2j+hNvgzPk9PamEBHt6J5UnDE5NOdtTgQg+pGJQcNhYYSe21mVAgM+6cDv6ctEen0/Mz6Nf5+ahYBnwtxB/FDjdqB+BE5uxnzNc1CgXJg3NCr1NHghN78N5oFP19H/F9aW6AQ6SNVpodVJKHbGjXMfRAFvIQ+LKF2Epr5VTzWKfib/+ngf2/4irmZKR1oQ73Yb9C/8QhI594iMNOJVa/A+m/rBVvmM6wNhza5wZFjaZe2aQsB5sMoNuVeePuiy4kM6bsnMkmx3cnlzeaoqLoaliMgE1OEfgKsSA2nd1TOH43BpWjtBiAbKVlRy6j0VYMM5PcMyYeIFCIHJAjwOn3mYI0Qkuvke96IXbKWHDXR+HTtA0jlGS6eBCPKUPzZ4xvdA2RfLuRb3BQIJnLlrmrgcpgLO9x90Bx96JyeTZE74mqYpw83xuiR3weor9IMl9ouX6f+CHSUEXOoo35re1tXtmvE/IgFNL/LH3Wz1cyCcIu83j1XUXbW48lo20pMUw5gi2xzEwiudNEw1qjdRfPa4j0eeYAd0JUSpJjLpY4lfOcbEBq/cTkg3WnQ/8YeX6q0oHcHooTjgR/Wx4yCx8FOqiU0C6cAZjK4lrygck5CyHPfh9VH2gr8lkUxs99oxUVDOYWD5YflPmNeSARL1OTGa6wX34Q4qpyRQoeAFT8ehkdAMJvLjSPA9xpMhARg8J4zqXME/VwgMAfXd3HvWNvlngGu3ApDAYByH510jPUVn3T27MenvpFC1NWE
 duN/+Z4m
 HHgFwFpLREO0xhEHZieqo8nfcZdVXe50Va0uxPhrqmNMtm9groNxneEe+4xsTPE1KwhdRGN2ewQxgkLyV5qB/oiUghqAcEGzGz8QTENt5nddWbhsnQz7uG2HYvfQ7lGlrjJAfuCSBEDj0oR0bgQ0RGOVoy61F5LmHwLfMxCYDy4jWR/zmZ0xTKhWyBNjgmalMpfTvK/VSBILEFYvQn3hr6ODpoepHoppgOe66kNQjhTJLCDmvljtUTGepzljjBNecLbMTqsRATUqjBwqlO69RG8FP/rMRWV8kLQbpmropnbOjEYFhcow+uCkRlatoalHOeK4hiK7rC8HjqYDART5v6V7ZmzLquDjTE6RqbTrvBZfjIjhVM8+sh5bNK69rHr8s+tU8Lv7BV1Ce8ZT37GkLs6wxzPoh/JNDff+Igrs5FedWiuLleZR5wbVEKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 09-10-25 11:29:57, Gregory Price wrote:
> On Thu, Oct 09, 2025 at 08:14:22AM +0200, Michal Hocko wrote:
> > On Wed 08-10-25 12:31:22, Gregory Price wrote:
> > > > I'm not quite clear yet on the use case, though. If all the user allocations
> > > > end up fragmenting the memory, there is also not a lot of benefit to be had
> > > > from that zone long term.
> > > >
> > > 
> > > The only real use case i've seen is exactly: 
> > >  - Don't want random GFP_KERNEL to land there
> > >  - Might want it to be pinnable
> > > 
> > > I think that covers what you've described above.
> > > 
> > > But adding an entire zone felt a bit heavy handed.  Allowing gigantic in
> > > movable seemed less - immediately - offensive.
> > 
> > The question is whether we need a full zone for that or we can control
> > those allocation constrains on per memory block bases to override
> > otherwise default. So it wouldn't be MOVABLE but rather something like
> > USER zone.
> 
> 
> Mild ignorance here - but I don't think the buddy allocator currently
> differentiates chunks of memory based on block membership, it just eats
> folios from certain zones/nodes.

No ignorance on your end. As I've said this is not fully thought through
idea. Memory block was meant to be userspace configurable unit.
Internally this would need to be mapped into migrate type or something
like that.
-- 
Michal Hocko
SUSE Labs

