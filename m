Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65A93606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 01:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ah5pKHle
Received: by kanga.kvack.org (Postfix)
	id 652926B05E5; Thu, 12 Nov 2026 20:02:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603BC6B0631; Thu, 12 Nov 2026 20:02:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1B26B0633; Thu, 12 Nov 2026 20:02:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22AEF6B05E5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:02:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 77CA64097E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:02:06 +0000 (UTC)
X-FDA: 85428294252.14.291D51A
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 93C8EA0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:02:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ah5pKHle;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794531724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QuB4gRralS9yFslodv3QC7A77JieK5X8DdVq10Sbwss=;
	b=GDdfjkEVbmp6cZCTh/LSh5rdpFrsVb6DErFPaE89TYOSC2bztNOka7H12OQA57oUCO2J4v
	QsXx/7Vqp6pNKrhBMM59dqQOy+v1c2kfw4vN6CvjN8xvEtcRUrD1Aj+oMuyI4tTCMahBRV
	E74LlqJbXZneY5JuAwamC2Yx3glsUmU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ah5pKHle;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794531724;
	b=cajksNRQKetILCPoA6anF6GA9393gWe2dW9xtLR5bwOwCEanBDj83Vh+cLYE+CypigzMkd
	xEIBKbtWdCzsiAA/uc54jN92TbE6Qvl4MM9B+aii4GNB6qG8VYvvvMkwoUdOlL6WBceoO2
	3Cfmuej+lEcsYktYVowaSTjkdo3o7XY=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-36d1b3b9974so37552eec.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794531723; x=1795136523; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QuB4gRralS9yFslodv3QC7A77JieK5X8DdVq10Sbwss=;
        b=ah5pKHlefUxShXsGRxLKQMCG/focVLT/Y7Oxf5mseif2xLrtO/gnM7vyRwENqXutd2
         G9ZETfOVpbGaPevcuYAQaX5enE6jeAJPTfrUg/y9dv2PoUFunxIHtfAeDpB4iQRSYkca
         g6qIIpgg6i2Bn6b+RmGUsmiHX+jjXAh0l+H4F7iyo+ccauoQqPGrbyELVk5zMxILar7M
         /gQbdCCrNoN+LHQhQPdPqr849whNlX6Stex+Qw9vosaQZxdsioRbr3EvTDap0P96yy+A
         ucQp6K+0MyEpwSHJg66o7m9piTLkD/hBAHG4ivjil0zIj0yjf2Dy2yc79SclnLcm7e32
         yZEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794531723; x=1795136523;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QuB4gRralS9yFslodv3QC7A77JieK5X8DdVq10Sbwss=;
        b=kux+5catxl+1tTOeqnnKme1mMg9bzHegl6N2hhspm8VfFsBcD3y2CC8cWuxfuzWt8D
         Iezq5ro8ZrBgYhvPjNwSy3XjRBMFXjR1KZR827S1gVx9qafmbVqDnJDvIF8d8fDXhHRm
         3B9VGqUScYpbfJmYs2Ba4V5x/gEi9cBp297dAZbCUBdeO9/HyVyfVvn+sDlMTOvlPrVB
         XCo2FU6o2w9JXxJ8LWBl7vuu4QIO13NM+TNzPHfzec30WhlmILwd+hEKLURiLxiubfdT
         Rfr9wu0FXQiFbWEnh7RHME3oy+YlJPxvkBzhgG4mJttR8gnWv2Hz8cxcpM2pUqvZx2LI
         Y9MA==
X-Forwarded-Encrypted: i=1; AL+hErHpp1u4RTrnQVMSkj0R7lrDAmtcNPIKM1ZHj/ukNeKdSP28locex8XBJX2XLZjCwCp+qbnegWEW+w==@kvack.org
X-Gm-Message-State: APuU4Z8fkH7vVcsOF/dXclc1A7J5+i+YtY4oR+OEznhLsyq0ua3wy7pO
	Y4n84f/0fQW+6chXYfv2QvkOL3Y6d0fbb9TBP9N1+KXsyYeZIfn6I+00
X-Gm-Gg: AYBFou04QK0dR7QXH9GxoW9X3E25ydD0qzt7vT761lbUtXGszhzMBneh1Cdn/o/9+e1
	uBYLHBuzlMI272owitH1dwbCF8NT83/r/Ls1kJQ3r2FSCXnlan8B8ssW9njzk64s2dfx1Hzbnd3
	j6fh4oBSH6dh0tZ4l0rJf6x72St6Upz7wrofivJiEt+gXjfLsKUP18ysugMATJP0F90SStNn5aJ
	aB72+hXXU8C53IQTuakxYU0/AkD+q6ZjU5NmVQpC4IYT21064XusQPxcCxNceYkpqgCLheduBpk
	eiJB2NWXmh1dXummTdhDKojuBWbnjZCjisAIur734IcsA7qXPqZh+m62b2GvJrLeVBEQJG3bi5w
	FHdNNs5lV81QPp+ADYEMYMFPbEwuNTRGOKbxl0PZ11dyZdP29AE5ShtHR8MXoXQ7/EAUjG9ZbnR
	8ejNwKdEXToPB6dgRxCNXsLp1GM+kcpdbxQ4zAHRiKxQzkhIOJ0ZNX1BYrTZIPsRyGohVWg1Ozl
	DBphVfUAYvgper9Xb8oEZDDWeUmXUmmzdi17wyck+RNiS3x19fEvU2CzMmBz9rxCyr1ua3Nx+bo
	IEQKBQZYxlfD6VvWK+t3PrQWtwYr4sO4fzrfVlpl6+3Lg8ytQcfYxyW0DHOCclSGZOxix7IdX47
	OA8J5NAVdJ/RI
X-Received: by 2002:a05:7300:c00e:20b0:35e:d21c:f33e with SMTP id 5a478bee46e88-379651ecb3emr1356356eec.1.1794531722833;
        Thu, 12 Nov 2026 17:02:02 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955332ae7sm4453590eec.8.2026.11.12.17.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 17:02:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, 
 Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Helen Koike <helen.fornazier@gmail.com>, 
 Vignesh Raman <vignesh.raman@collabora.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Nhat Pham <nphamcs@gmail.com>
In-Reply-To: <d812b71d-b7ec-496f-9404-add2282105a6-agordeev@linux.ibm.com>
References: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
 <d812b71d-b7ec-496f-9404-add2282105a6-agordeev@linux.ibm.com>
Date: Fri, 13 Nov 2026 09:01:51 +0800
Message-Id: <179453171134.2553194.3867422839676762696.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 93C8EA0003
X-Stat-Signature: 33gctmp8g5su6aqhyopsc4kg5nmdmj6g
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794531724-53981
X-HE-Meta: U2FsdGVkX1/qTaRzGnBJTSfei8upagvUgv1U8HTD7B+pmO8UjNWkp7kh1fR7CekMu1UwGXJvzPax+2LGY8YjbksFWV57P8QW7gqKNlHV/gri8FnlWrZZh/8IEh7KI9dlzIWm+uOQR+yfpZkwU6lThHeeHe7nEYvKaWfUacTW8RkwbbFvHLIqbi1CBouoLkhJSy3TMiq4/QRaWzkhkvL55WxBx7MUKrTNaUdgN+IkMQ0E0DxjwhMLGQhP4FjHs3l0MJ192ZR/6zTBapdw3Qwtq+2dT/ZYGGvEoUZpBlKgX24wIPdA0JQ1wohsV1Xa/BkJkSgzEqZzl3G8v7zHQbG1iM7TeivV2LAKy0d9XeZGMvVmdyQXPnnx/ZjfoBHMkFkOYXbw4U/x/NPtFbsw0hm3VITpvSLQHHyzu6CYrUWyWeNLyav4KRpE1DFeLbws4YTT9nkCBwkVlRVIBHL36Nxzp6ylYz9DViuA4FRmJF94HTUuXayPRYetEdzMnsrTRxgDOdoeWzoUZyIgK4Jix4F+TlmhTYd+9ha6o/zoU70RCra0Nk+tMb9MwgJCnZwrLTMLyS/BSRk0oNkLqddM+lTLQoS63M9XJRF8m7OcjIWlQNUUCYQrqGKNk4X6imetJGZXZBZYDNJyMW2mlowIYXXsaadC3tNl94Tpbnji7RLTVK9eeA/UuVyZQLuvy/fLLK2qLh4Xic0X3NQHkPZlYbC45NYhw72jLEmJwvYCo0rXmDQ2WETpk7ia8jLvTwICyrAE+i8+Z4Y/sYq+RhoPLQo/SdE6J2DJ8Ymqjv42o5gsujGWS4eY2Q6QYTKUg2E9bJO7riBbXUz9GWIvPc/ByWdtXPsB7C0+CmW6S+xh3FJfUdR+2XUV79WZMBWSaLqacNBj4kiLwVu5qaDJeDd1LqdQftoMRxiwc2WR68tzfHDBWmnGNpbpEhj/yUwAMOR94JYJyn0EwVKNY7XnpzBBEJq
 +JS2cJ1R
 qydfT/DXVt8wwKUKMZM0qD8g15/IpJJ6ijAX9a/yDz/iwGQjuSbFoSlj3rf2cQN0rjfTXh4eK/z4ZUMsQ/ZWaVpEn4NYPVEn4wqbwqqCQspadLMBNss58WeSkalWdk4HN4uez1OCP8CCBxeggwL7EHlGaEFZpfdSaLtvb9Q4Qul5J3c1sMMqDhwp4JDRWIAgKNWn1HQmv9HBopLExe5dKbl8mg+8GtJ6hMs5pczOFuE/eouBg37D+d+KRhY60kiFepAtZHUEpaVHgdVXqyVbyCa3JYO+yniuLMxHUZN/2H1rWBCOO2hKDa81Zd9Eq6pCsGe0g+6p8ThscDcBJSP6xbdZejOSVbAFeDOXIaoiZS/Gqm9qk26FPi0A4EATznO20O4t8O21JA5Jy9qYnGZlUoOTmn0bgNbhHZcwHXrHIBNi2+VSG4cq71JS7r3He93RjfTFRnvgFUAQut4iJLEeYhmpwWeI2xeIMWzqj+GxPsew5r1MJp/nmLp5nRBrpeEh8aoucA3G0CWQt9RkV64zdyOjEDKqrOEmSaY3iXlKZ7KJ1MYY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-12 13:29 +0100, Alexander Gordeev wrote:
> On Wed, Nov 11, 2026 at 08:41:26PM +0800, Xueyuan Chen wrote:
> > CONFIG_ZSMALLOC_STAT only controls the debugfs interface. The class
> > counters are updated regardless of this option.
> > 
> > Remove the CONFIG_ZSMALLOC_STAT guards and rely on the debugfs API
> > stubs when CONFIG_DEBUG_FS=n. Skip statistics setup silently when
> > debugfs is unavailable.
> > 
> > Remove the Kconfig entry and replace the existing CONFIG_ZSMALLOC_STAT
> > settings with CONFIG_DEBUG_FS=y. Update the English and Chinese
> > documentation to match, and clarify the pool name in the debugfs path.
> > 
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ...
> >  arch/s390/configs/debug_defconfig                |  2 +-
> >  arch/s390/configs/defconfig                      |  2 +-
> ...
> > diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_defconfig
> > index d44674b63715..83193ef8efb9 100644
> > --- a/arch/s390/configs/debug_defconfig
> > +++ b/arch/s390/configs/debug_defconfig
> > @@ -100,7 +100,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
> >  CONFIG_IOSCHED_BFQ=y
> >  CONFIG_BINFMT_MISC=m
> >  CONFIG_ZSWAP=y
> > -CONFIG_ZSMALLOC_STAT=y
> > +CONFIG_DEBUG_FS=y
> >  CONFIG_SLAB_BUCKETS=y
> >  CONFIG_SLUB_STATS=y
> >  # CONFIG_COMPAT_BRK is not set
> > diff --git a/arch/s390/configs/defconfig b/arch/s390/configs/defconfig
> > index e00e252d4694..694a309377d5 100644
> > --- a/arch/s390/configs/defconfig
> > +++ b/arch/s390/configs/defconfig
> > @@ -94,7 +94,7 @@ CONFIG_UNIXWARE_DISKLABEL=y
> >  CONFIG_IOSCHED_BFQ=y
> >  CONFIG_BINFMT_MISC=m
> >  CONFIG_ZSWAP=y
> > -CONFIG_ZSMALLOC_STAT=y
> > +CONFIG_DEBUG_FS=y
> >  CONFIG_SLAB_BUCKETS=y
> >  # CONFIG_COMPAT_BRK is not set
> >  CONFIG_MEMORY_HOTPLUG=y
> 
> So DEBUG_FS is selected unconditionally? Please, drop this for s390.
CONFIG_ZSMALLOC_STAT used to select DEBUG_FS, so I added
CONFIG_DEBUG_FS=y to keep the stats available.

OK, I'll drop those lines from the s390 defconfigs in v4.
> 
> > --  
> > Best regards,
> > Xueyuan
> 
> Thanks!
> 
> 



