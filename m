Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D34B9CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 21:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E728E0005; Fri, 19 Sep 2025 17:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276848E0001; Fri, 19 Sep 2025 17:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C108E0005; Fri, 19 Sep 2025 17:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 01EB68E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 17:06:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9ED191DFF24
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:06:17 +0000 (UTC)
X-FDA: 83907232794.13.45541D4
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id C3DC020008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:06:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LqdzgI2J;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758315975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWPFq5XLiSe5P7Lh1OFm30F3HOSWuJ2B7iUyo634nUk=;
	b=UIJf0n1ueSWXXCNvSPvtpOGFa4dMRGKRdRMRQkAyGUzHy+cdFKldnmry+zPkIT7Nu51bZG
	jNKtCFdED4NMYUXDZtXwh8rzTu69QXRm0zCEEk6ZdUnIKjqH5MdKeaCEJVXhNFM3thd7/y
	Owp2uwmA5hehkwKG14c7nWncX2+sehU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LqdzgI2J;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758315975; a=rsa-sha256;
	cv=none;
	b=A/edbZc23DvzeC7NKz9JceYv0ulwtSrf9U4rctIqG7ZnVQNqQm5DL7FOgZ3B1gDocyclXD
	mpFa10KmgIpe/1k4jJcFD4lJzdIZX7Psddfy3G0jEV+o6od1TzpzaB2r+3bovXQ3Kx00q0
	wAdtWGU23QzczED2xzPNimFzdqsqYOA=
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-ea5d1270b56so2831207276.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758315975; x=1758920775; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iWPFq5XLiSe5P7Lh1OFm30F3HOSWuJ2B7iUyo634nUk=;
        b=LqdzgI2J42AQu4f4cxWFTWQWm5zCbbNZYyie9mgRhisJEOiSuGgpkaet5ldoRW/Lgq
         ib1TL9AwZZKp1vBq7NdwdkDO6rfVeConnkKPx9IjvbA2uRuJy9ITml6FG6+iGZNHoFre
         2zKNnkxzQlsPo5vTz2iZX8zCD2caF6MwxYQ5NsI5OgkV7J7eTCgxFH1XMRqXLNx0mQPe
         XtsHa+CUY9uAGbXT69oeWyJBtkJtS5Xiflz6MlHIM5emaE+D6apA33XgDr/KMcrPA6wG
         dgFp7Guue34r4cIOqVf2BlrauWIPNbvDG9EyBY3G+wVjx5nHsGQDhWA5sfyvmGPWMYHZ
         hUNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758315975; x=1758920775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iWPFq5XLiSe5P7Lh1OFm30F3HOSWuJ2B7iUyo634nUk=;
        b=F+uS6wVuVv0ZVAYWbl665rNCCayWDRVCYqf5/A8J/mjX8MHB0xAn47HT+pPIJNNi3R
         jLOXZbS0hJSBBEx/CPHKZGh8TfqjZZWlcS6xAgTVAKhG8LlkCxF14y1yQG1CSPnyqy0V
         0d8fj2AYmgl2ANRhEjz/BL8wnQEDJSMYIG6k83dLWGcrWJWp9wDS/MldGd9EWnmEM7YN
         FwdDGO7S/7E+SndKytmRqfSc+weIqupQmh05Qjq28NSY2+/V7CbGyeAdXKIcTEZuNqIJ
         3zthydYhbplJmd4YIn/a3D8Hm8sBhh7SwA6bYBipUpuRrhF8SgOgoy5jbCaVHPGA6Rf3
         Qozw==
X-Forwarded-Encrypted: i=1; AJvYcCUxURKLl/GzvmuvRQpGTX7z3n8jekr/I2rgmNwYkThUhhzp0a4eOHu+SCnBlkKwr/K4N8syoRJwAg==@kvack.org
X-Gm-Message-State: AOJu0YwGpQHgH40cYdM5o9QijwFIL6cmanzuOi5OgLAbftMHQrf2WeqO
	2quf7Rf8pUYMk2ZOzkDE9Y3BatU3HwoP5Pagu15uehBX8DQTnY5PaFlY
X-Gm-Gg: ASbGnct2uKbkH9olfqx/Aebq+9GKiCf/mUNUE70KD1j8AZ+n8y9vy5GpLpM3o7tnSzk
	FyTzZWzK08mERbTXeckFUYI/q1FYhiL0/EGPN873882aISPVTKhR0Q7rd//+GBkLwIBZcLFS+G7
	fdr7Y5QCoSvjusHoQPKz4xkKmSA4Z70VSSTgLTqG2jq4hlJuTYGJS3k8AOaIlMloCzG2658rstA
	oYK/7gqw9SIBhzC9Mcm700+7/KrkT8Wtxksa8byS1LeeCHNG8oIphUzI/6qoVEM+X6xESV+xDKY
	Z/A5rlSw52Tv58mmMg78+2o75NxH7jaNnjfYm4Bx5iuZ7Ct9+al7I/3/6wDYRf5xvr3+k9VfVY0
	xn+n2zW3UwnSe+xfjKH72jYAIaY1Squ0C/ySqS0PfJmqg6gjJVpoJ
X-Google-Smtp-Source: AGHT+IGu/B19WQElReS4mpdnS2mhyC2RhfwEOQrFXpAd2AUmLIVgGNgyYw5nlRAj/98u6sCZST88wg==
X-Received: by 2002:a05:690e:c8:b0:62a:83f3:a575 with SMTP id 956f58d0204a3-634779c2cf5mr2920693d50.8.1758315974624;
        Fri, 19 Sep 2025 14:06:14 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:b::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-ea5ce85481fsm2010344276.19.2025.09.19.14.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 14:06:14 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH 0/4] mm/page_alloc: Batch callers of free_pcppages_bulk
Date: Fri, 19 Sep 2025 14:06:11 -0700
Message-ID: <20250919210612.1975459-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919130644.f3a4afdf0c2e51bbec59b6e0@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C3DC020008
X-Stat-Signature: o8aiyburdbbdsz9ztxgkscx7i7hd8p4i
X-HE-Tag: 1758315975-29479
X-HE-Meta: U2FsdGVkX1/OSfQAuCrW5VozFWb3jvA4WNh9G3IelIdHBU+EuOooopDmO2HdNlUjXqXzaZcSCRxiNW1bptTcrde9z9iuXFZaB5dTzqutPOtzFZEKADYVMj9y312lKN7EnHU0TTVstl0tdyk7Cc+z9qEcz5N6kh1+SZGAyvyc6qiRtrxoCHj/EgquM3NaUC31ZjnxwzY6fBnC/55e5UnwrqqwWbQAGXIhowL0OUatgp3wZlI3CfZWA20pfVGO48HfQ7cb+Bop7GUmy6snNY096MazGeEoh6D8zpqxzmXV90s/lmE9Ziq4Tbdyu3mRXOuoyUrF9t7T0HHNSsNd5AuyZzTzouORldXZz4Y4eUcW0sZeWkFH0G+Xy/Z4RcsDJAcasmi/eHhgrHXzzlTHu9Oeg0xI4CUX41JsfTLWK/Micy46HVTiH0dHVpop1ChujVMFV3lNpeyc+WupwiS4rAIhoM+Dec4Lbtn3Q6d6gEd/sLth0dQQVZDFUcGIIc1NHV3BrQ4ErPmIXi3FrBBicM+MiYbWvvgnigtcchaDlvZ3l8W2HqCpdkHZHG/NR4BpPI76vdh5HwwHHkM0VUzyE6LCAUdQruboROCHs7LvVcYFSLEbp5mZmgDIHoiDt+PqksuHUvYtISf5OkjSZK5lLNSVX3xh16DHfTJZaFJEeYgz25NSLPFg7LJR6n8G7CVZZM7iD5X4/4EK6FY09SbGAKgD/B/rAoEZj+IUZ1Kjazc2YNKinjmz7ukOaMZvoqMrC8ukhdgMsOodPw5DM2kCTq/iHR4Mko38Ou2/vPanF8tV6/olEF1q47Mes/MBYGJTsWAeONvb9W+o+bIohUf8OeSEXHwIzihM5utOseSxK5kYOPwGL1NBy3f34GpeFXWAB3o4UiKDHOHT9iomnPFeuCEa2e+MyrEof7ikpT3vLKGuXhLnXvh8itl63xJyb1VtSeFzb3pRNWz5iTxZ9C30bzz
 2DSpmWZc
 bP5cEHvXB8XZ5iZzrbfS9hfWNodQeOXtk6X3TByTcO3qA7DRsN0RDKHzkhYtr3myEc+DZTZMlpP19h+ebK1/fetosWv7J9YHtS/ceon+MUan5nRCxD763nv+LFAG1/vlX0hg7aynR9Oo/Bt7jp+ux3Z2yWtZUraMb1olL7A9m9iadV6TFm0jY23WTCLnphiHToaaZa+x4cb3XQ2JAVKnG/jfVBuOzAoNQLwHmXZY/d+AhiJJYZqNWu3QhRFgzOKp0PCQdtXNCkArpbWC9+1gvJ9P4TSzJr3lVVYuB5+sG8SYGj4L7Ik68WecWDofmyuMBq0vGDG4+yQcW9UjvWzwAqkRDtybHP/y83CLCmHUap+ofWQH2MNFp+KqcV5HmSYbws8I2KFejgfIYFyR8hl/zCt5r3AmI8jzgpGSd2U1HTpkrWGUunbA31dt0OwDd+Nha6/XPghIqSCHUwe8Ioggc3asWGh5OQlG0DPtCr1nY4jDfIfhlYskl5C+Z15ah3wpMrnBH5M23dU+XqUG0WIahggsLWx2nRv72Bx7qDTBc4KWwXOS+KuKlEnEw4gLX6KeubuKr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Andrew,

Thank you for your review, as always!

On Fri, 19 Sep 2025 13:06:44 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 19 Sep 2025 12:52:18 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > While testing workloads with high sustained memory pressure on large machines
> > (1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
> > Further investigation showed that the lock in free_pcppages_bulk was being held
> > for a long time, even being held while 2k+ pages were being freed [1].
> 
> What problems are caused by this, apart from a warning which can
> presumably be suppressed in some fashion?

There are softlockup panics that we (Meta) saw in the fleet previously. For
some reason I can't get it to reproduce again, but let me try to find a way
to trigger these softlockups again. 

> > This causes starvation in other processes for both the pcp and zone locks,
> > which can lead to softlockups that cause the system to stall [2].
> 
> [2] doesn't describe such stalls.

You're absolutely right -- I was revising this cover letter a bit and I was
going to link the below message separately, but decided to put it in the
message and fogot to remove the footnote. The message below isn't a softlockup,
but let me try and get one to add to the cover letter in a reply to this.

> >
> > ...
> >
> > In our fleet, we have seen that performing batched lock freeing has led to
> > significantly lower rates of softlockups, while incurring relatively small
> > regressions (relative to the workload and relative to the variation).
> 
> "our" == Meta?

Yes -- sorry, I think I made this same mistake in the original version as well.
I'll be more careful about this!

Thank you again for your feedback Andrew, I hope you have a great day!
Joshua

