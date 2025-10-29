Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4992CCCF9F0
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9FA8E0090; Wed, 29 Oct 2025 11:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81678E0045; Wed, 29 Oct 2025 11:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9703E8E0090; Wed, 29 Oct 2025 11:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 859FE8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:50:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6F5A88E2B
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:50:48 +0000 (UTC)
X-FDA: 84051589776.09.221B55D
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id F1DC6140005
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:50:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=usl1uaDi;
	spf=pass (imf26.hostedemail.com: domain of isaacmanjarres@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLSSejf9Ov/rf2h/EN+lGG7qdblHRyA6VuFB4BW8g0E=;
	b=tv5FEZsoNeE2PtZMvN4z3I/gOZUFfyAJ9CfvZwlUcOUkdk3Rsfx/wRugi7mfpJRVhkVVkv
	2opLNaO1iFY7fS8mOEPApqFoxAtAtCdD/TeHNToKndCl0GWIdAz5wSJLLb74GwGZ78f9tF
	WmYWXE9NuxjvkTfB6RAOdG5dX9NWaiQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=usl1uaDi;
	spf=pass (imf26.hostedemail.com: domain of isaacmanjarres@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753047; a=rsa-sha256;
	cv=none;
	b=0YfvULYpNmBv5a66t201d2/Nt/baBVA1ENDMJQOXQWXDldYiA+xizCTmfKfFc9PES21oWv
	u3C49aYI/N+ZGTLIQyYMw5Y9qnAFrErxc93Yl2biLOj9vwszYi29+31tjaoj/3tAkOR6nG
	y4BUQrJGtzNBGE3M/NC8n+3rJizYh1s=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-27eeafd4882so252335ad.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761753046; x=1762357846; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XLSSejf9Ov/rf2h/EN+lGG7qdblHRyA6VuFB4BW8g0E=;
        b=usl1uaDi2r3Wje9XneH0zfTX1yYTpWPl1fX8ZDa+nlgqgH8PJVTNaNvQbuBpAbPzny
         buRG4B3B2XbBBq1JQ7sKaYDsK2ifgtacmgLFtfQatMEqkgZNSu+bECD7kz6gUUssT2wA
         paz9I1LmrGpyqWO1GMR6Cc3ZXdSv1bSTSnkAFjSQk/XseZrGsMbTxuWGQLJYbQcC1gpU
         eIUkpv/q+58rGjpogYcmOw9xj5Z3Qs6ovE/JU+Gnft6zMLdMi2Ix3y/CtroJJi/ScZcA
         NI3V1QSyPAsS8/MKn/vdrA5bOQCC7+v979AzAud9dRVTP7083CURRwS57oHvQJJl6m8w
         DuKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753046; x=1762357846;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XLSSejf9Ov/rf2h/EN+lGG7qdblHRyA6VuFB4BW8g0E=;
        b=JJQce/Jdh3X9b98xVJj5wu9SipnZYvEyRxhBtYuTfcpICagbbJNIQ91TS8A2Eo5/q9
         NU+0MbnYU9jpElly/lIxL7Ilu1/XfCzilPGVScg027jWfaYZyYyH8Eq8yUNe+DygzcX3
         qYCxvlqVkDi0kaksO/nNRtQJGW29cTKV2Mpc6xG3LhCxI0OuF+qp0UzyJPBrgwcf73N5
         WHRYJf1cl7Ndnlzz9alaiMJvCTjCU44r87TFj8v2qbgCEcynZgzFFQCAxAmDSfOYxWg8
         SI/l89YVGl3pMtSxKHaB9+WpZn6pI3ytUKKzSs3tCdC2avsMF+Lh6p6Tl/O/n/np+7jh
         /2oA==
X-Forwarded-Encrypted: i=1; AJvYcCVWPowvlH7s5jv7HkGzyGOjvg69XCsp0lpae++d+UAyRFUyqJsZnumUuAai6aTQHl08oieNQh57Qg==@kvack.org
X-Gm-Message-State: AOJu0YySOQX5KHS3Vvrg5m2hVtvDcMYppw615BclLKxk1p9m6IqFxYH0
	R5BWZmI/cmX2yZxQ/RHxrIU1TZ9rwNDhDAyx2UgJ+tfAZeM1A5QM3wG3Ml81yNywbg==
X-Gm-Gg: ASbGnctOGuGkElmG3zj/RpphdxMFjzZfSqhfBk/V39+GxHL3OGzld/D0wRKmsCpeCu3
	LM7hyXiith6G4T93xKlbF9E7brl8U2pjIod/B0+DIwp6IzyWbOWVFqxVM72UNQusI6NjkT6Tu5n
	hyKmxcB9NWh2RbuQq1Dm/CyPkzjcZYoKOj/Tjb8YYAllAv14AIslucxqUziPa72Sad1blniqSLb
	J4neXKBzluAQx+KHsFTTfiQwNwiTlXTcqu/EJEkbcciySegEu6POLAi/YRlkVvkQDwDXX3YwX3E
	kQzznY0Z+eVkhNMsLQDwtbsKWl7ih7JvKLJoMnHkeiPZDJtOGW0zd8Ypzbb/tgzfNLbsjui3f04
	BUZY2CtK0EZZjuUeY99tmbZVafDe/uJNSQNUFs+XsBrc6aoFsZSlezpzfJxe+ANfNj2gOnzCJnv
	QC4PQDayWDJJouOoHXVMpk+tykBzv6wiPnUzIpgRxLLsj9k80a6oaY
X-Google-Smtp-Source: AGHT+IGKPx3RLfl6Sze4h/1XGsrW5jd0bsQlcCb4PLueO0OQww5kd42KAzAHDNBGaMp7vPiY2Mr9QA==
X-Received: by 2002:a17:902:e783:b0:294:e585:1f39 with SMTP id d9443c01a7336-294e5852cfdmr2782045ad.14.1761753045254;
        Wed, 29 Oct 2025 08:50:45 -0700 (PDT)
Received: from google.com ([2a00:79e0:2e51:8:9ab7:9682:d77a:f311])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a41403fa75sm15654178b3a.28.2025.10.29.08.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 08:50:44 -0700 (PDT)
Date: Wed, 29 Oct 2025 08:50:39 -0700
From: Isaac Manjarres <isaacmanjarres@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
	kernel-team@android.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/mm_init: Fix hash table order logging in
 alloc_large_system_hash()
Message-ID: <aQI3z0x0gZ3T1fij@google.com>
References: <20251028191020.413002-1-isaacmanjarres@google.com>
 <dcceca48-bbdc-4318-8c07-94bb7c2f75ff@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcceca48-bbdc-4318-8c07-94bb7c2f75ff@redhat.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F1DC6140005
X-Stat-Signature: ju6fp4jcqxegpzg7aazgofdkaoienxo1
X-Rspam-User: 
X-HE-Tag: 1761753046-80862
X-HE-Meta: U2FsdGVkX19Z+5acaNLJvnX4mrun5tGUYnb087/Pmaxex5xUUSvpEnwTBeSRH+7wiSu+H0vHmVN5g+GxYYfYKLKtQDtyF2rh7IJXRSip6K90J31l9B9nnbZYsvVwXqwcUW+0A/XVqvLjy+EGr4blbyIFs/TBo8VHAssjvmz6xzSfS9myC3ZIJx/tWHe2rwqYoY8VeQxh39+ocguzIe4b4ae9e3XQhaN258ztNPbErrN1fbfABp99TH2UTV6xzOsGH66UCH09FeQNjuTVYOF91yx50JgH/+cL22vkg4XZYsOSD+QPhhCAWBv5HEFolPC+bCg3dVj8OSMx4QeLvkFnEd74wZUmK4Wvud6gVEwtPY7sWS5VbX0bjlyMJxeTrkqvLxRvoO8fmo7xRfvRCh2cNpsPsWHyA6/jgXZqYWZh/4uAF1HWisDFaqCFGO4HcgInZsY3DFdPUk3paDoPQ005pB34h8jQKfrfcosYKBE4078rxNKQDLK6gPYk7B69Ay9LlSZu4e2GlYj+dzFbNmKU7Fj7oMKGnn28wPDYTnQfpADM6/E9HHJj2NbWTEESfqPeU2oNxIIvDkPNZhTlwK9L1feWhxoac0A76NUP/x4QoHsSHaNU5dz5thfVgWD4iHtshNfODQRiahW6PvuT55QV8j27DNma7w2RNGVHuqCEQgcHz44HhFHeQQi7aC6xCaJNhlKSb6P0J2Yw+iLgsa5QDwFXwDr6gJXZoIaIjMOJpAefKhHMIDy/AZFKQHhv7H1J44WkUO8UpuuRR24j9qbxriKRez3mzJzAQRfs/OAsEzEYJ3KtusOurH1vAJHhhDH5SXOg2GPmivjXmatFjZcczOQUMc/+uUEUczFGsit4AQ/W65/yo50mdFWX/VzeGuNIYIgiX4CvAZ3t7dbECHDghxjYWKWYfxvFNuEtgbxQIAwWzCCX6Ifip+XEUg6usM9ICrBouZhDZ85qmr38td6
 FeRGGEmR
 gAUrBj9IGctAUottkhmNpITK6w9jCSjQW8KcHUGW/sXbBHkAUTv1JTYFYWYgnvN0gEUbISMgkwd9AwWNn+tcc0YHyqT+TDsyBiKJax0y0gSpmTvsd2WzbCPPgyMLreEK0O7q4Nlg5uiTTZwaIO74dYrfkfVNp6OpdT5r0lzfzLA3XtRIU/yt+lOdqsN3hfhCLE55QYVXd3uUuIH8cpqDkf3Wyek6OFLTaXTNFWNe/JQkmOGenXQ7sUyY5Xp9uaHkDqz9TQSQ2GglDkzXBO+SrLvh0OPmfaAsoAxe/MBrE3sQTXnXh5HlZGgUeUQE6qLnjhf080gSTnc40Jace9LnX3F6CX0IhFnuCmR86A+P8KiZIyfiEyQpxX0ZaC16BSJy1LnkLDjfJtUCv37IgJ5amvE+bADCfKdyAUtiPMgJ9YrFnsIcXw83JxFlFswt71i6ekQ/UnyXVc6b4GTE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 11:03:18AM +0100, David Hildenbrand wrote:
> On 28.10.25 20:10, Isaac J. Manjarres wrote:
> > When emitting the order of the allocation for a hash table,
> > alloc_large_system_hash() unconditionally subtracts PAGE_SHIFT from
> > log base 2 of the allocation size. This is not correct if the
> > allocation size is smaller than a page, and yields a negative value
> > for the order as seen below:
> > 
> > TCP established hash table entries: 32 (order: -4, 256 bytes, linear)
> > TCP bind hash table entries: 32 (order: -2, 1024 bytes, linear)
> > 
> > Use get_order() to compute the order when emitting the hash table
> > information to correctly handle cases where the allocation size is
> > smaller than a page:
> > 
> > TCP established hash table entries: 32 (order: 0, 256 bytes, linear)
> > TCP bind hash table entries: 32 (order: 0, 1024 bytes, linear)
> > 
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: stable@vger.kernel.org # v5.4+
> 
> This is a pr_info(), why do you think this is stable material? Just curious,
> intuitively I'd have said that it's not that critical.
> 

Hi David,

Thank you for taking the time to review this patch! I was just under the
impression that any bug--even those for informational logging--should be
sent to stable as well.

> > Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
> > ---
> >   mm/mm_init.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index 3db2dea7db4c..7712d887b696 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -2469,7 +2469,7 @@ void *__init alloc_large_system_hash(const char *tablename,
> >   		panic("Failed to allocate %s hash table\n", tablename);
> >   	pr_info("%s hash table entries: %ld (order: %d, %lu bytes, %s)\n",
> > -		tablename, 1UL << log2qty, ilog2(size) - PAGE_SHIFT, size,
> > +		tablename, 1UL << log2qty, get_order(size), size,
> 
> So in case it's smaller than a page we now correctly return "0".

Correct.

> Reviewed-by: David Hildenbrand <david@redhat.com>
> 
> -- 
> Cheers
> 
> David / dhildenb

Thanks!
Isaac

