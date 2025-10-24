Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5903BCCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 07:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554F38E003A; Fri, 24 Oct 2025 03:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504FD8E0002; Fri, 24 Oct 2025 03:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4048E003A; Fri, 24 Oct 2025 03:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4428E0002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 03:39:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7908160DB4
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:38:59 +0000 (UTC)
X-FDA: 84032206398.30.59C5D9B
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8771EC0006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:38:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JjpMiswr;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761291537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eWjiXjrqyzK/iXD4R/873eykQlEHswHIXOchBtrT4ts=;
	b=mnzMbVXP+CaCrR6NoHn43i0Fh3OeKuBnzS+Y88kIpARa4QXq7I363tkC5erlBdEi7oRyg9
	3WJGgQOrRa117MbVCUQj0sbVhTMa6IQwJSf6lhI8QdSjDI3V7n/HytVe+vTX9bhYF/Qcn0
	fc0D7Y02eN1TnG0osuw0dVdQLJgBZl0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JjpMiswr;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761291537; a=rsa-sha256;
	cv=none;
	b=Hq5Pw8sgTshgf5lkVid4IV5IgxrKmqiVSGeSCrnFiJrKMjvFZLsnWAe5fr1ChH40nCUQd2
	4TsAipA6IEh4pQy8ndC7QTYzj1B9oe13XDriI61132/2t9IzUUfrScJ0NFXX3zxYdKjyWj
	dbqPBJFxCCcyDdyHBUi7B54lI5hp7MM=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-426fc536b5dso1225277f8f.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761291536; x=1761896336; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eWjiXjrqyzK/iXD4R/873eykQlEHswHIXOchBtrT4ts=;
        b=JjpMiswrM0Wb71vmvKE+MeK50VH9w+/q1imv6oBWPvaYVF6t2MKD4o6nvrj8z+OkpP
         tgAGkmDGpYS1znrn2KYhsU+ZjAKJK7osX6+IfyqxvAK5KZmrIWl4JlkovLX/4oPMEeNR
         Whf2rtP7kFpVGodRmDUq5MRTO9wRCdDCXmLUNW9XjYezMkevGL99Ybw//TILO1ndcJv3
         wDDF7+I9Ub7mJzG5/+mMLdOHWw2CUEpzrKASQe2bu4bwDkubHVmTrJYg7pSFsn/W0KAF
         9OkJkyKa/nmrQKu8K5iCG7iPRI+tkJNyXqkzL4f1rWj+j5Ti1o7PjR+wtOG6IW/I1xBA
         bO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761291536; x=1761896336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eWjiXjrqyzK/iXD4R/873eykQlEHswHIXOchBtrT4ts=;
        b=La4q3EVrqZtT/az5By5WKV2re9T+PxuscJQCTB5PY86yZsUYfw5HvunZGCEn4ABto/
         HxQPFIYjvHy0BYUNNpVpgWCiOuP3E1hDnthx1kr26Kpytp5zpBwhe6qHHE15Gy4WnQPH
         v9wYGvX+MVPIE4WeOET7fBhJcv3RU6lg/7y6GdO19ZmS7PhgJahPk9Pw4vbppmfHrD49
         NxzTzOQJ3XqRLc4QIOlksduFaUlAhM0UrV4rcwOpl5+svXZFn34TDPotmBS1Os/gY/6w
         YTlraZ8jaXDy8PUvF2SAsZR8Z+byIkeSZkzZg0/VEVe6dsGk9eTcOvWUlY/tgyxo2eV0
         eTeg==
X-Forwarded-Encrypted: i=1; AJvYcCUbTVqoMen//EiDHH0MPqtJxKEVY8/bbpOOHsNeDzdFlTdHjYvu1GSvblTPlYlhhDLRXZyhZBpmUQ==@kvack.org
X-Gm-Message-State: AOJu0Yy9OxTHCYzhcboV2UovAHUbATi3Yg4Y2q3sPkAtC1tNjhMPrAHL
	PZ6CtDz+RdWIL6xSkOplHHXU75/PM4Apm24B8IzMxhSwPxednCoq3wHLjkm07JaS8vk=
X-Gm-Gg: ASbGncsjg1O0E0rbiiLRffwlHWyMoLbq02QJCSDFvFQncd13JZLryU4t9eORZKYNc92
	XHTv5kjDmBMq21g4g1xWaNPGMrL4dnI8D2HG3SyGJyxzQdQyxnki3gkMhc+E/SAnACDpDhPXtIZ
	YjWR5W6MmnlvpTVEKkWqypGXe3LZFn2cuV1OKTXQvyYxp0tHBzU3OS++NWhYuzBd9y+5vDSIEZJ
	2cG29PJ5L0ltpIlGga6DaGVgO7H/z9e0fzuqdQAlypM7ON5+8z7YNjEMqfFoRGnPZTVG2XRWGPQ
	Y2sqke5/vNpkcCTzpLiFfRYZZHt3tsdxCMAIG/A2pJlhQz5gRN/2Fa9UCglPmCPkSYQlEnBgBJN
	LD+fJvwvtJJ6S5RKaaDm76e+y+djscsruO/bcURTCmkjphBVa3jFB+ZRFQpsyxF6tG+oNhJcJYi
	erYjsO0ThK+fTThFRysuWBh7FpaATYCXA0
X-Google-Smtp-Source: AGHT+IHMbLAdC/xuB+rLLbFga5DXcsyo5YyU6+vhemg24zckk0wkyGy5nZsG6GH1Suc+bZEQLCrrkQ==
X-Received: by 2002:a05:6000:1861:b0:427:809:eff0 with SMTP id ffacd0b85a97d-4299074fef0mr918259f8f.36.1761291535892;
        Fri, 24 Oct 2025 00:38:55 -0700 (PDT)
Received: from localhost (109-81-19-73.rct.o2.cz. [109.81.19.73])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429898acc63sm7914006f8f.27.2025.10.24.00.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 00:38:55 -0700 (PDT)
Date: Fri, 24 Oct 2025 09:38:53 +0200
From: Michal Hocko <mhocko@suse.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
Message-ID: <aPstDXRerYqi1O2X@tiehlicka>
References: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8771EC0006
X-Stat-Signature: 8xfasufyco3xz16xqsexqr7kmswz6ouc
X-Rspam-User: 
X-HE-Tag: 1761291537-466551
X-HE-Meta: U2FsdGVkX1/mFsI2dX4rzeJPYHSPwCsLd911yzh1ycmoNKHBat12bO508mZfD73cd5cxS42BdWGNIAQkYT0qzNiwKPzvrC4XHuIPuo7Cs+K0B2BMEkyBuATOf45Uvh65JS+mN0wLOaGQkO+pcUy87DPB9zO1x7jAOe1tNRhlJmSzD6JHS97qHdtuTMJt9D3LQfCBv6H/2JbL6E/lTP1pGdV7DpMz5TGH1fKyHalwkawEUdcr/slfhEJ/Nna0cBWoTmxqIYyOfO1AEkCqWQmXRPUytpBs1rHyeKj7oQ0VqwTTsWb2vwwz4IEihFQ2LopVQf7TnWMFP/yyxZjQzHvUwziUi0/NmiujqNILrF1y9Oq2AL04XPPHVGvzfJBEEVed90u4yKtPANzB5LM37PZ3/6bYcRQFTz4CI0ypkzleLU/DOEUuO9Tq+5yofe5Hj7gfek6gGz+tKXP9CW54yOO7dFFg9iB/x78lxANQalsj1vjUPHoOO9bgiVPUdojal4cxCSGK8MCki4VkamObu0fq5fkerpngZPekN53tIfBX7J//uT97AAYUpFSrTX6lwBNkUvjN/l6B3NsAXPp3m0dhEypgWW24I7wrt/o8T9uSgEDyxMnoLBDpETTqJHj0BBBeFhHBy46IXHCCq2KucILCMdFPOYNxKeGf+CfhMvJjmSzE5R6Pk+PibfL38KBI2uBBxDTOepLfA8yUvSpu8//z0othoArwwehMSzWwcyHNhq0/grWeGExXBY9SuIM3ILS883eARrbPGuaiNGXqP5yA1IOs/DuUj5KkgJy86Nhsm8NPmtYnm0fbeOF3rJDYCtcNWfKfpUl2euWXkDfv83BzWTX7FRxpDDByDwswM+kY0GgZM0qvBwinGxtji6fYfOSJBf/KkxjXYxGrF9CMDVTmVf9TxhLFR1y8O5wyHCMJbIjp9JLEkwS7Utzrkx/kQlgkZbtZNfJFAaz1Rfz1+Qt
 EblvvkPM
 bfNbFgE6LowQdSb75r8MaZQCM+jeRqwnkJfQwzv8/Ry5pvtjbjqKUAgyuHYcdouilj8GE6iNdBbLJzfTdnbCIu3MIMNXNK4B1ilWnF+7T4xwMD4Rzc/FbZEsKIyPkrtfKecCN0ilqan28NQYr1izk5QcIafjYt6jjIAJiqN4jHhAx/kokXoMxO1yxmXr9WoOScIHPqb5FrybmQwJRsZEU1ntFRt6rG8KcEq3DorncZwHW5LTL5n113sEnhtc5SeLgVakC6AzSTyH0ICj2Vjemm/dyzB1x18zGJk7IhiLZWzbFCGZv7oCintx6BiY9JxSxPoH0MFrnahuHnvmnTTAiYeVk0aORHGJsHdSjnS5IB+70Yzc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 23-10-25 18:12:02, Dmitry Ilvokhin wrote:
> Allow to override defaults for shemem and tmpfs at config time. This is
> consistent with how transparent hugepages can be configured.
> 
> Same results can be achieved with the existing
> 'transparent_hugepage_shmem' and 'transparent_hugepage_tmpfs' settings
> in the kernel command line, but it is more convenient to define basic
> settings at config time instead of changing kernel command line later.

Being consistent is usually nice but you are not telling us _who_ is
going to benefit from this. Increasing the config space is not really
free. So please focus on Why do we need it rather than it is consistent
argument.

-- 
Michal Hocko
SUSE Labs

