Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96C1CC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 22:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A192B6B0088; Wed, 23 Sep 2026 18:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C98E6B008A; Wed, 23 Sep 2026 18:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7796B008C; Wed, 23 Sep 2026 18:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 642336B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:09:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD4B5C0162
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:09:26 +0000 (UTC)
X-FDA: 85246419132.24.A1DD804
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0FA16100003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:09:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KGcNMUlD;
	spf=pass (imf14.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790201365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0vfvvH4VnMd4dK0iJViHA204XuBKefpDpGV2LA9qE58=;
	b=1gaaFU0BfgHFr0YKEeoBV/MoVVYCNPsYNH+XYO89Tb2ppSqupU7CFGAKCU8dqE9s8kIQLx
	9akAOUmCrCY4J76kMhZS9c1SEfcYe6g2+vdddqVQEtRVXOFByIIBLGPO/9J2VC01dYe7S4
	rT3xjadt+HKJufgiuZVn+Hc17iyn/5c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KGcNMUlD;
	spf=pass (imf14.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790201365;
	b=XJhFZ4BtK/+C/3JKd15qTZ8df+sqK94kVVNUbpuXJ3/yC1ce2HT6jmEblkmrTYoVhnxdXN
	JjGPt5dwI+hesyUufuQdehRUxChmA3L80/Y8LhHsBtqIo/qlad4LILhD+Vsbs7PR2NddKQ
	g5duZ0/ehmlN7fk7ZbscnZJvP2jdXFg=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso10344485e9.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790201364; x=1790806164; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0vfvvH4VnMd4dK0iJViHA204XuBKefpDpGV2LA9qE58=;
        b=KGcNMUlDivX4rkW5eChl+/SraYtUl9EZn4gyTZDop02DfZJll1b5YHPt2p2226B1ft
         TqoTQGjJOWxpkcIqhrLk/bCAX4ozjpBSeTrUm+zPOIzfNEGGE5MaRivr/V30WCbGZgmK
         y2pziz4DioOm9LOHVPtuQrTRjEj8ZoLi0SGfdB+oAWXyuhFYkSp/9qSc6097XNcbmsMg
         ExiUD94SvpWUtKMBJGOijiJuCcU9J1lf/fmGEZTDtMyzAyksbc3E0RkcIspt1/GVcWVB
         XTRB8BgRBdlI9mm4n0DaKWAB4rxMqn6oT/PgexK7DwYpLpRNj4XAqWSmX3mygjYdZbnT
         95bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790201364; x=1790806164;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0vfvvH4VnMd4dK0iJViHA204XuBKefpDpGV2LA9qE58=;
        b=Z5e5DyanC2/SBsis2Zo/dp3EOTOl3jJ5AVc8zxUfDHNarAE0oAfBfkwKqwGJv/6/lo
         AxwSPZyXIjwXZbjllUqwzcu6hfhZBidakxn8Ik2QpdcGuDROzcIbvvb3CrPL7ib59/c/
         40MqNr0yamTKnqILk3nHn4XtUccIQ6N/zq3XfiS60Fjs0dIrRXHSemQ+ku6G/36Xps7I
         DcDoA9lzCi9WPSYePf4x5D7vDbAdW88LsQgmKvCtD6dEtfL2NMRwLXdrTjcrRszhUfbA
         u7hVLYMYnX4AEQ8w6NCqzphWMYHGDI8QGpheEB3+gQFmDx4lmODDdYSdvM7tyJ2AOsgD
         Xz1g==
X-Forwarded-Encrypted: i=1; AKwUvBwg+3tbjBGxaVOmRjSgqG4GjDs6z0rBFmSGecAOq9YoAkz/WCVydcQqJe/jZ83j97rp8Fiys0uJQw==@kvack.org
X-Gm-Message-State: AFuF++ki5BvENq1IW4t5+PW/y1UJ4MdqQFUKuVPmqbTTMV/2q49P2p2d
	BqfD2PlKr9cxXI7l3coMQvxwjMRXGZQ0C0aFo+JslERzvAT3zeyBZ1Z0
X-Gm-Gg: AYBFou1Y3IBNE4/3LTDZdlVCiFmRz67N/ZfDd1H6nY4NS+F03z+875GX9lbNgy9JLpD
	HNf546+fHoCg6+TxmVc7SDvydKeDGYe5zXlx53fK2ac9fvWnbh0vzxtBfSXj1nai8UAzOypFKuc
	KWe6b56MIcxBRGGJNzkw8QENGxpwtBW2NROuIp80wO8ZmZLvaA0LyDboO/vERdUYS4PE5YSCO7b
	62toa+j6YN/s3KzSaaLTgNgRtOi9SA9WyFog4GXtDagUW+bX3b4A70g6rJPKfLA/ucy+LENAdSD
	3MBzs4Xt1f/rbsbGPWXgh7tFy9KlJvgTSDtOoA98kfDCwdR6las6rHsKS7Bctwc96sdSSUSrBWd
	moBn8ncj/WBf9ca1rk/NFp1Jd+aSQZGqgKyFNM9qa3I7H6FwL4+Rw5NgF7w4Fsq3764kJZ1vSaJ
	Iww0ikc3uSeFtxRWchCUWlWoX1zQNKkcpxyvmJMU2H14yabmnhYKS6U0zmuJa75g4LxOlWkshWD
	EZF0TFAJC5AjP2Vc9V8reyPuVLxYn1z/UYGqMCTzCspIZlOqrD3e7tNWinpgg+SfFgpZn4SeJSr
	vKF5AVKatPHowGqBZ4T0Mo3voGY9tZraK4w6wJcXzXfJ401RWHeKXHrCTBOIHq+95+50oJz/Oc7
	bqmYWw2CLVTRO
X-Received: by 2002:a05:600c:138f:b0:49e:602a:b4ec with SMTP id 5b1f17b1804b1-49fe66d2700mr8501195e9.8.1790201363197;
        Wed, 23 Sep 2026 15:09:23 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a4a2-9601-c082-2dcb-3f3b-92b8.310.pool.telefonica.de. [2a02:3100:a4a2:9601:c082:2dcb:3f3b:92b8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdf3541aesm57899075e9.0.2026.09.23.15.09.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 23 Sep 2026 15:09:22 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Zhao Li <enderaoelyther@gmail.com>,
	Jinmeng Zhou <zhoujinmeng@bytedance.com>,
	Alex Shi <alexs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Hongxiang Lou <louhongxiang@huawei.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wupeng Ma <mawupeng1@huawei.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	fvdl@google.com,
	jthoughton@google.com,
	rientjes@google.com,
	vannapurve@google.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 0/4] Fix HugeTLB subpool used_hpages tracking
Date: Thu, 24 Sep 2026 00:09:12 +0200
Message-Id: <20260923220912.46905-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260916201307.5618114cbac4af52d98aecfa@linux-foundation.org>
References: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com> <20260916201307.5618114cbac4af52d98aecfa@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1xerdnccjz4czwubyp8bcjxuuseam3n4
X-Rspamd-Queue-Id: 0FA16100003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790201364-555684
X-HE-Meta: U2FsdGVkX1+EXaO1xEBoRWLU5aG45VLiz4Eqznna40Sl8j2QgIkMsPTDAr6OVWN7lWZeqGW+vHXprwUh/wMwU1mlfAakb8XlqgIBpnaKwdRJq44wjt2asJfadAvrcqd3+jxZxDrwzniU4P7UnWO8tx3yu5D/u6oruGSNjLSgNw4o2DLfuBoHBDzcYqs72ovfxPtlLAHtoWsuBP958F+8MeSwuElh5EmJn4DfDaurcnRnVA8R9xp7REW13SFbbGAKyHzhc0YzdR1LI80yx6cLYn+qfN0QFbfHV0LhXs6V9zctsCXYjgae4Te5lDlP2/r/CiNv6SE7UzJ2hTI0xKTqKfD3LYg+GkVTsiM6derrzd8kCDVxiKx+6bHr/m1D0DFdYUAN9WpytqL7I+NCxY6yy0BNzz6slw08UnPqYINZwid/PKuwzFgge2s4PP0P/YcHz2meg6Y8c7l8htV1cUDZN9anpTKn2QtxLRa/TDe0jPidLolsMDAn4CiYeg/0+D7sSjEcXtGGF9jimNVlU4A0pOh2yTBHz3pOQetbTaYgGxzZ6hxiiCv5/8zivMyZMZtvlmHnHNf3FVsZQdze2gkQqq9sWSzAV51ifwD/I6tl2m2yH7sA8mMWvtm5ajJA0iOMH0J70OUgImuBFd9T++hkhKpljbDdZhMBkj6OU06RbVq5/VoUAiPnEvjSsktrAdnse70KTePvK+tEjS4xKsb/wJtt9OKBSGCiZ2JvQVvDyQ4pGMvOqryr1/3nwkvk5GBStfXxhTm0EdzEJG1RGnsic1qr8+5oRI1Z0wCFyfvsKdycaczOt27dS745Gr9PtaVGU0pR62gw0FRU0R4bJYz8SW8sr3Wd+1i6Db5PVCvKJ1SeRdueowHcvnJiJoDRvx/q191iryVsGP4vgEKApL8Mv0J2O3+IhQnkPZEaFbdAGb5Z7uVJ+yVUDogYNujsDiIvrbhKJ5nh/JhxJ7ZLup0
 4XzxojJd
 MB5u/R2w/ocSBgOvKd6qPjGGd5fIhH6d9Ye5TOcbrIPk1bb3VUHLTwcN0jJutFTFa5AYgO7UOWqidNA8EA877Z2HhfCLfxc86fFxbqoO38e3zqsboLAkH9KpmxYrgb0hvawPqm1Qe8VkSD4b/yuhv5ylUbnY1WEr6yM+vocO4kdTUbeSdOU6AvPWl8y9tn/mevzkDzxjhYFxtMcYxrhDNJGZXdfsHkG0Idr1RgF1qUq+JvzWeVyFvoax1u7VaefVriPNNxAwJM1H79HTBDgn9cf9cJAZvpoC0bkQZRnKgLFVhgZo7SItPY+ZI1RzZV9uC2EslSnxTUALundh7YbeUHXh0S7omdWX9Jbx0S5vTQVq27jaEc8ygxec4I2Xx/kvhf29e3/Yaubga0CQETG6y0k544cDT3Q6HV4suU4e+Ep0+ErI8dH/AjRuBKhYI/MqUR6V4er8P2HZhknDYsWBoQRtu6yfBrUiUEQGilA5A2dqB/iAtzgkdr2YqfsBUxG4CaAEQvDFh445L1viXiW6AwrDuIOsmURfh4K8WVKmTt719/OdolzilkJTNpEWyjI8fUV6FMAQ2AfWETbwf38+DBd2SsO7Jf7S/J0oM9bz2e3aCwsw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 20:13:07 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> So if downstream people (-stable maintainers, others) follow our
> recommendations, some kernels will get two of these patches, other
> kernel versions will get three and some lucky kernels might get all
> four.  Are you confident that the patches can be split apart in this
> fashion and still produce a good result?

Two things I noticed while testing this series on v7.3-rc3 (x86_64
QEMU, one CPU):

1. It overlaps with two fixes already queued in mm.git, so I've added
   their authors to Cc:

   - 3/4 rewrites the same out_subpool_put: block as Zhao Li's
     "mm/hugetlb: fix max-only subpool accounting on
     alloc_hugetlb_folio failure" (mm-hotfixes-unstable), and has the
     same Fixes: tag.
   - 2/4 rewrites the same out_put_pages: block as Jinmeng Zhou's
     "mm/hugetlb: fix subpool minimum reservation rollback"
     (mm-unstable).

   3/4 doesn't apply to mm-hotfixes-unstable, and 2/4-4/4 don't apply
   to mm-unstable. If I read them right, the queued fixes only handle
   mounts with size=, while 2/4 and 3/4 also cover min_size mounts, so
   they would probably replace them.

2. On splitting: 1/4 applies cleanly on top of both queued fixes, but
   in my tests it made min_size-only mounts worse on its own. As far
   as I can tell, that's because it starts tracking used_hpages on
   those mounts, while the two error paths only release it after 2/4
   and 3/4.

   HugePages_Rsvd, expected value in parentheses. Q = the two queued
   fixes, wrap = 18446744073709551615:

                                   rc3   +Q  +1/4  +Q+1/4  +1/4..4/4
   min_size=4M only:
     SIGBUS faults [1], no files (2)  2    2     0      0      2
   min_size=8M only:
     failed mmap [2], umounted (0)    0    0     3      3      0
   size=8M,min_size=4M:
     SIGBUS faults [1], no files (2)  0    0     0      0      2
   size=10M,min_size=8M:
     failed mmap [2], umounted (0)  wrap   0  wrap      0      0

   With 1/4 alone, the min_size-only mount loses its reservation, and
   in the failed-mmap case three huge pages stay reserved after umount,
   presumably because the subpool is never freed.

So it looks to me like 1/4 shouldn't go anywhere without 2/4 and 3/4.
I haven't tested older stable trees. With all four patches applied,
all the cases above give the expected values, and so does the
partial-truncate case from the 1/4 changelog (Rsvd drops to 0 after
the truncate instead of staying at 1).

I'm happy to rerun these tests on a rebased v4.

[1] https://lore.kernel.org/r/20260923065714.20781-1-kmehltretter@gmail.com/
[2] the scenario from Jinmeng's changelog:
    https://lore.kernel.org/20260907132055.26696-1-zhoujinmeng@bytedance.com

Thanks,
Karl

