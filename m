Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E095CCF2E3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7D096B00DE; Mon, 19 Oct 2026 08:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E546B00E0; Mon, 19 Oct 2026 08:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8AE6B00E3; Mon, 19 Oct 2026 08:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 653666B00DE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:36:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8A30A06D5
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:36:24 +0000 (UTC)
X-FDA: 85339323888.27.ADB3213
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2F64A1C0011
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:36:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RcVz0rAk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of error27@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=error27@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792413383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=em0NrM2bDMBNAYsHZhxOy8+BDCr4wFVKc/N8ia9VJ7Y=;
	b=OtTlTV15yvCpiHdwFyhq9rN2TZedxdF4J//BHAN4ehGo+P4s6IdKjEIbjamsoWpDtTL7aq
	HMNBl2VJzJnhW2OWe6hHJ6l2Ppqf46EFuiZrCoxu46caGtYUnQFlByYmp+wynXmfmk7N+7
	ZvIaIsA1525/jl9/tS0ar7XrQ6CtNAE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RcVz0rAk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of error27@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=error27@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792413383;
	b=OtIhUViPsmDp7ZBWW0gYru9K5RVLDiyEoqxNs65RnFcwHQX5ERiIslFQDgh2bIrvEQmuwI
	Of3DjsHr6xMpaimL/fGbGXabB5hGTeItlpK9Uwx8fga9d7KH9ymRNkURl5n8Q8M8I64xLi
	A9Q7sk4/A/VG6dkWWGhZ5Q2t0nQlv2I=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so2639259a12.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792413382; x=1793018182; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=em0NrM2bDMBNAYsHZhxOy8+BDCr4wFVKc/N8ia9VJ7Y=;
        b=RcVz0rAk37y7iYnbmzxUgt9LPOu3X48gD9aha5u/71wrLsH8dtDd6lGG0FTLjccotj
         gRwCHiWB/9iUNIC9+0Dy+nbLNdpMSlJJ2iTBRMyUbkUDYlygLrMrD9pKH/ECUjcvjLjf
         NtAmmpOms5HtCygQqAYwpg0L6hribu04Fy+qKLwwXqQgEdz3UUHR/F5r/7Byo8l5k9gj
         aT2VJXomlFW64dGpDer/S34AmmxXOTEgMOqwV+8pEs9y1Ub+CASVLQCzWVdt4S/nL543
         4wtxpTaC1Yx+AOeJ5MC+sVb7V2xP6/zOHNucDxgu91okRodgJuFibYyq9zpke45EuUL0
         +eiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792413382; x=1793018182;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=em0NrM2bDMBNAYsHZhxOy8+BDCr4wFVKc/N8ia9VJ7Y=;
        b=m2nxd9gjmoSlsrn6Zcv4RDkQGMoEItzmv2VDqh6mDcBbl3cIAn6i2PCA4e6MLsYzRD
         /5t4AGOebU4Y3Ri9sWmuAntmXFSWq6qs9okDEabqDEBIAUcJ5MSjNWirjnswiKy5Xc+k
         D+bWqhWsqfgueeOS+GX1Z1Lb9iAwXb4f12XneRK2+l69LLy3TIM1uyYX2N8ZvRRJIjpn
         qX+GjH4HtVGOp9Edk7lFq/AIKeuNCmFLc2bdRzuipnElEE0daLENuaY4r9Rrh2rbnbi9
         HSpSXaIqge/8IkH5pIQSWjm8BAs+inZlVOZr0t+pnFKSnezYloe63kHnOz738DRTt/ss
         +r5w==
X-Forwarded-Encrypted: i=1; AKwUvBxHw44xplYxdIhKug3irl+c+hFZJ6Ef+MwKvR2x0azfc5rXO4mU1wNpSkxLdyonGvbdGYc9n5h+7g==@kvack.org
X-Gm-Message-State: AFq9FYIiUVmvJ+bAzi3tMGxCUCswGSpzoZTh8CSI0XFivbnCfwgbmXVd
	c6v6zlInKLm98CbTcNVbC4Feb8UXNVYA3b0o+Dz5h2aBBMKB+MgTC8zaAQosIFS0txAQdWKe
X-Gm-Gg: AYBFou2P3U4J9q2ldxrLN0G1Cuzc+nSodvUJhQLeif4sSlgZVlE0eP+Ox8eSdxLBvS+
	Yv10/+Ao3uEZOmV0bGCxUBuQxO4Zo7Lgpae5j6yA6i9WdcdRIyfwn7BaF6CjrlvylBIE2AaAqY8
	KcMvDD5Fzzoe0P4/uBKJFBX+vdq+voyGfyWNJ4psASCYPDPpTO9BWvVP6ISlEhtz7YHvT/Tx66v
	XEvmDSblcvDUBuQdoHXZKS82jMGCEI6KP+QeTMn6R6by5zaH1UFIW7fN54hDZYtK0/1wNoZeaPc
	IXRrx/ljoLzkJuKKaUfTuDcJ1zGMUyQR50BLtdC/XJ6CzE01Ql9hshAht37ICqfrDkbQD/+eYKu
	19xc1iKTpZnYCa6P1RGMl4snbclzOLsUZThKTLBzLAsY2+PoPN95ur10pSS9zKH91g8l07f//y3
	evnC3I84bzJOx3CyDPf6+RECnbL4B5ZVDHyiFEXQCF/YbfrxcNiCs1BsyIJC7l9Ae5EKQ=
X-Received: by 2002:a05:6402:4551:b0:6b1:c355:c7b3 with SMTP id 4fb4d7f45d1cf-6b3a818633cmr3493949a12.25.1792413381456;
        Mon, 19 Oct 2026 05:36:21 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b38a1e70c1sm3799334a12.30.2026.10.19.05.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 05:36:19 -0700 (PDT)
Date: Mon, 19 Oct 2026 15:36:14 +0300
From: Dan Carpenter <error27@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] tools/vm: rename tools/vm to tools/mm
Message-ID: <atYOvqkdVSgjXZVM@stanley.mountain>
References: <20230103180754.129637-1-sj@kernel.org>
 <20230103180754.129637-4-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103180754.129637-4-sj@kernel.org>
X-Rspamd-Queue-Id: 2F64A1C0011
X-Stat-Signature: 4i7ogwggn9peuw8i5igxo4b5ige657da
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792413383-207443
X-HE-Meta: U2FsdGVkX19KyCMjVchvxQ9HcOgQHwj+Jmki7QR7CYk+n+qo8QKanPoG4s1JSezv32zGHpHJCL/z1HFU4UvD9GmobAht5Kaz6aR9OcVrH5B2JuhzPWFkFq85ss2jUSCY8/zfA918kywlk6kApBqrcI6+LLeaxxe6RnJzunQZ65PgkUbO3u3AVcg4iZKDBrbOFyD58gh9ArHMOGzrSxf0mQL5ghEgbJRnu2PM1I/benADmhRDUNIgvy0hM2JodL4bKDWoYWgV9KWLWYRUhG8YpZwv/+U6C61q+QR/zyYJRKWzyFsT6QlBDEfv0K+rQv8XSjkSdEjVIHSj3apqj9NpKeeLyy2RGCuGkysK5EEeylP4SiwwteerTsQtB8v7jRuVkILP1PmBUbnzUtBey1irwLjz1KreL+b9QFs8pVDBNDg7lCWWt7KBPiTHGmUURKDTLLfcu3GDFC9/DssxIFsDVrU4+c2ZQmpKNSC58Iz2lC3z2YwgG4dS7WhjpUQ+nTEFwOaxfh6hWRmiACIGo9zKmO4LnEyTaJKFH+E9+10UhpgT3RGlSS9+ZN1npVAU9u+HSz8u1gkGeHhdCZbqsTq0JbzMxtkloEtZbvT/+lRGTyssfrr1bDdXc2lKM0eWk6h4gfxmgNR5+EMXGmAXMg9mWwOQn6kXN4lPiMHTDNleIWVnFpvDV3Kz1gNBop+4T41jIJd9Io/LPvPMXEEkTizaFXQnelfBKV3wT7e2TweuxstX1UcTVc6TFGNbrR+UabLRc1FX9DtwfsGXSvIrH9bEFzS4/6gYvNrcJ6V+v3575C8CEtofQZiNMdXKYdeCrkW3D3Y2td7ebmx3wrmXWf+23hYhoOLibfy+NkhC02MADPIbZkgAob8zejXPgG2NWrc0TFT/dfTfX74AOb8KOJt+wLEjxEPmpprdZflLKgG9kNh1DnUsoi768MXNfAHT05yPrIELDUy5ZcdWN7Yo/O5
 TNq/wyzy
 GNQ5nbVzorBLo0rD2L5JAj6dc/5/H/EnJo0jmEc2+gg3AMa5sjhjQl3pJcCrUe8vlGYEGJ8nRpdXCDvQnjz9kefiwm2+Ng9NsuOuBmPj2Jmgu7+ROmbimp88XP64ZKgtNhEXdY2ABzNf4I4J1gVe8uQH2hVoOBvU23oE5vyI1OVTMUTNaZXxDNSvaCdibJI4csifJfe0Ko+nCiik70sMuscTNnv7SEtIAntQGJd6k4MPioFDaCji1+khNXVtBRCG4Kk1xiKPO7ANtDgIE32p8iiBPU+zOY7QCEuu2n3cAs2XGWUiQlcfy9YAww+LCg4WT6VC+YpdkUiCV6Nj+HrgeaOHXDTtPkPJUYJGOd2AvwaMa62N+kGiuxOk3KdgTCvht3H0kRtBph0ZdbyqX83EpZrjHHxTYcJG7MRSGuNK+ERd/Xcq44xbEjoPOju94CMeSnuL26zh0GfblTotFNfQz13LuoPNuPTWo7qqaNRr8L50r/FRDH1hZNOW0jN5TO1W5v6fF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 03, 2023 at 06:07:52PM +0000, SeongJae Park wrote:
> Rename tools/vm to tools/mm for being more consistent with the code and
> documentation directories, and won't be confused with virtual machines.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  Documentation/admin-guide/mm/idle_page_tracking.rst | 2 +-
>  Documentation/admin-guide/mm/pagemap.rst            | 4 ++--
>  Documentation/mm/page_owner.rst                     | 2 +-
>  Documentation/mm/slub.rst                           | 2 +-
>  Documentation/translations/zh_CN/mm/page_owner.rst  | 2 +-
>  MAINTAINERS                                         | 2 +-
>  mm/Kconfig.debug                                    | 2 +-
>  mm/memory-failure.c                                 | 2 +-
>  tools/{vm => mm}/.gitignore                         | 0
>  tools/{vm => mm}/Makefile                           | 0
>  tools/{vm => mm}/page-types.c                       | 0
>  tools/{vm => mm}/page_owner_sort.c                  | 0
>  tools/{vm => mm}/slabinfo-gnuplot.sh                | 0
>  tools/{vm => mm}/slabinfo.c                         | 0
>  14 files changed, 9 insertions(+), 9 deletions(-)
>  rename tools/{vm => mm}/.gitignore (100%)
>  rename tools/{vm => mm}/Makefile (100%)
>  rename tools/{vm => mm}/page-types.c (100%)
>  rename tools/{vm => mm}/page_owner_sort.c (100%)
>  rename tools/{vm => mm}/slabinfo-gnuplot.sh (100%)
>  rename tools/{vm => mm}/slabinfo.c (100%)

Is there a reason we left the tools/vm directory even though
it's empy?  Is it for backwards compatability or something?

regards,
dan carpenter


