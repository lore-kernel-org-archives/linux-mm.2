Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7446C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 19:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 064766B0088; Sun, 27 Sep 2026 15:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0155F6B008A; Sun, 27 Sep 2026 15:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6EEE6B008C; Sun, 27 Sep 2026 15:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7A276B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 15:20:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96936A0A9B
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 19:20:21 +0000 (UTC)
X-FDA: 85260508242.30.E00D8C4
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf08.hostedemail.com (Postfix) with ESMTP id CD781160006
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 19:20:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qc2zporw;
	spf=pass (imf08.hostedemail.com: domain of devnexen@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790536819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCahJ3O+tXX0CfGzclDhULcHGoByJJvACQgWnDRt+Os=;
	b=DYRwIuF5wsz6barke9rO1j+00ltSWjFr8Ltc8NsnefMfWtCSjBzi/vdH6GsptP85aIHm/c
	dZpsguy/l7elQS2LY72ypT5r643t3lzvMdhwrLR1EiFHcdshcdTp5sIzoJ+L6Tgj0BGwau
	XABasWpv6ztQvRQf0A29PbbdC+NTJ9U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790536819;
	b=2QKCDP3LzDXxC8DCpWfIwXIT2uLg4it3MjRJDMRdFo/pasWkOvKXFtWHjgwpHOEL4gmLK9
	ExmCb923VE0A1b2pen7+gjnYQTXAnGMVTaZ7h8P7sOBgajDA5HbI7G0w8l3nfSKdqCbNhf
	Tq373BPGu99C4BOevVZL8kfAu2Yf0OU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Qc2zporw;
	spf=pass (imf08.hostedemail.com: domain of devnexen@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e7d2bb404so7760185e9.1
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 12:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790536818; x=1791141618; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MCahJ3O+tXX0CfGzclDhULcHGoByJJvACQgWnDRt+Os=;
        b=Qc2zporwAREjF6Sx2lChAjWb+BeDGnlU+zPj2xhRpmv70OFHwGTKkESQqT9IFX5pmy
         NdvDbzsFgZsRqCJmzlYuZk2/WUfkMAa0axppT6nyXd9uvgI/6YzKRmj+0Ov0CXp6eIQA
         T7O166IC9vFUtVRmOlRIwwXVvOg5dYMjsHBq2CqZBks93bBS0+PjyAF34TkhqGAC3OAh
         +yuzbDvKLHbgyoJgcP2xfElF1ZVJiy+HcBIn4RQNwAd24W7zg+rcMZ/Rss6ZDXPfah8t
         C28Tadwwznlc69U44S57tOcmj7BKCMWziTGpSJYeJjxmB6ODxdwHELEbpsZnmo8rAEWJ
         R09w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790536818; x=1791141618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MCahJ3O+tXX0CfGzclDhULcHGoByJJvACQgWnDRt+Os=;
        b=EMaPv3YIeDEOkid7eSOk0DLqnuudmzl9E+O173IHe0J6baZgKfq+fKzryMVllgWjfd
         TxHfXb87RonFcJiWoxYIE/plQ4WRclGFteOyqnBDdWNEjgwg6FaQdpK8pLq4rlPB4MIi
         0r+Ij9glu+8ZUE2BIWp7KQ42g4MSsOIA45csenjro6pjuRrOPhNgdeDypDtjdk/zUbJD
         xXTi1yc/K4YpCyQtxJsnfQ8alQDQMvJOEvYZYw0mdnkKtQ9ONFB4OM5g2XnR6qsxa0HT
         P6PFxeLNZjhgYwQBQldhlp3MnbEtWfsLP1qluLRlOyj6iqVcXx26ej4534JZaHo8uIBn
         ZgGg==
X-Forwarded-Encrypted: i=1; AKwUvBzKLWZ8X8nmWeKO1Rc06bB8Rr407JNaJcCg+QDQzldlZnbyTAHm//n/lAmlHwrIADKBjuceBl2yUQ==@kvack.org
X-Gm-Message-State: AFuF++nywsyqmwLxFcTVuJkQtio3UtPYKaLMIveF69rIGy4/jtfTJa06
	HJhNR5Jsc4bdPMzOypUdJyWJ9tj737bz4yFaK+xJxJFoj6IsQxAjm6bU
X-Gm-Gg: AYBFou2lW1lV4/X0VAFmq5NuO3G1Lflwkx+IDitTCEJ8GZPPxYFrJnWNyya9tMMMkEp
	EWo9Wf1+ngZRGViiPGsrC2pDIGzJIk1KVzmAx5q3LZiB2Qss/k7DPuQe+uK1I9a4U945vraoOtH
	GffhsdyeUlJFHUruK9Ct3482kNZ2bloctuNMhJsCrP90Uwi2LxYobqMiam4tml0UaimvwMR3QbD
	1H6R/JSbMOmg35cMthNNa1XJT/Gjw2MrRVUlqq3AZ9lRnrK2Cot769ronMnKqKcpdA+XSX4XfPP
	5HLOjR+Eow6/nVD1De+55plpWHfypDHBDCtqYnGwH4axKxv4AogeDgUt2YSZfcTz8S531jd6NfS
	o9JLu5V5TTfk8pDSDAQNZ97BMEyKg7Pmvc6Yfz5kikzWAWLiMKhfuhTekhhsLSTCxrVeFjsvxZK
	JJXtv3Xf5vLCLGIDy+1jCeSuQyDrIIbeUO2PUKH2wFsdQS/1lNXjmkSJpbV9STCru9V+R9oLUdN
	SxTvV8gJCkRNUl3R+40JKg+hr4ejub1CnXanq8z6Q0EVEbWfH7LvBnL66E=
X-Received: by 2002:a05:600c:4f89:b0:49e:6581:7baf with SMTP id 5b1f17b1804b1-49fe66c80c8mr198488725e9.2.1790536818014;
        Sun, 27 Sep 2026 12:20:18 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0017998dbsm117774805e9.14.2026.09.27.12.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 12:20:17 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	brendan.jackman@linux.dev,
	dakr@kernel.org,
	driver-core@lists.linux.dev,
	gregkh@linuxfoundation.org,
	hannes@cmpxchg.org,
	jan.kiszka@siemens.com,
	kasong@tencent.com,
	kbingham@kernel.org,
	liam@infradead.org,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	osalvador@suse.de,
	qi.zheng@linux.dev,
	rafael@kernel.org,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	vbabka@kernel.org,
	weixugc@google.com,
	yuanchu@google.com,
	ziy@nvidia.com,
	David Carlier <devnexen@gmail.com>,
	devel@lists.crash-utility.osci.io
Subject: Re: [PATCH v2 10/13] mm/sparse: remove SECTION_MARKED_PRESENT
Date: Sun, 27 Sep 2026 20:20:13 +0100
Message-ID: <20260927192013.144672-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-10-54d81d65e125@kernel.org>
References: <20260921-b4-sparsemem_cleanups-v2-10-54d81d65e125@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CD781160006
X-Stat-Signature: gopj3dm1y6uu34p4qyycs8gfqwqugjco
X-Rspam-User: 
X-HE-Tag: 1790536819-803654
X-HE-Meta: U2FsdGVkX19tauerzQOQKnWOwq3esLzjsSTdK1mMpra+HWXMvZNcLvfAU1WjYa+mpbgFKR+UCCouHbMkhfr8nHDz6kjX+y+w6DjOVlvzMVq0AT1E+IPNkauYcZJ2Pt1DBeAl+CO2jzGuyf2z6whCpPdbZe4VNhtDMyoGP2HHm6ZTWRGpDSRj0G97jykfFTWt7CW3YuFnG+jbaj1jscbpKR3EGOzD3rH2mDA2I1d1+ehkx7VY/n1O+U3oIIg+qDxDVbsL2bjvR+UBUW3TEj3xReCNruhEoSX3oP87dfuFrd9BkJPStR/D97UKCFouWsGe6+QVsbKzKhnwoaX23kv81ktZQsW86EWIcTBgp2ENj7NN3fxF5Ve4vkSrmvXD6tyUnX+s76LiGX0r8rhtpBb0jvYh7geTSx6n9BPzbFGbuyGXstvrBu6qljNCjKwIR0rC/tMBkWCtuIuY/znvrSHk/SpuHm0Pol9DM26/WbhPtvWe6W6OOBJvIpdqEOGZmoJZqXSUPa/YbdY0KpnYHYAgDzPANKHzxCPVyouK+PimmBXC9kATMaFEAvSzPcytMVy2m3ZcqDZFUyMHjVXnyzbxuQusbqa9BumNA4YPhnK5Ukinwhu5BG6lia5NZChnOfeQPN/OeQHqTf02AfqeVS0hKYM5/AUxZw7KxTkOIokHFN64rwDez84q5Rlx95OCgn/rp4ib86PxjUlHZkdd/0/ac8Ig42cUQfy5NcpfDmWdjaLFOJig7tclR64ESsSkMU2m/a5CPc9b4BPzPcWXFLtl7qmX7U9eNRyJyx4pkapMmGUe+00CG7uBktZcNwLBnyvZ7FKy6zY+UXIL6fubF8IYLbFlL47TBJEu3lLYV+9kusPn4NSJGyS60riJsiexI8cPADicQSjTEE1BNz78RCFmQfivOTu9PVpOi7qw/8VU7EbuRTMUy0h5bAAkHO/vH7Beoom+1KV2/i1Bo0COTkw
 /VWscniZ
 yIQxmLDuQrwsMZUNxNdQUrwjzQN1s0kD5MOx9fx/Bxv0QWjVBTimleTX20kwsq3CoETSdFx1K4P3K/gLynfUU9zfgjYwS8Fu9cjcSQ1gGd9qGuXtSkXyPz7hvZIlcdvgCQjt/mBI0anJkxDm6rrgQNtVBX3yMgu+CtpXbC1dJYGN6lrue3KxfWfGkyPgOpMdiDDL8UCYuPiWfrwAH/vYR9zu6VlBL8b/jcBpMiXZBZefqVXSULA2RsPZjaniulfBf8pR5UwkQOStXR2wYeHsGjSFfAib2/8GUNq6mcCrUGfHfECQ0UYl/pllYcvMxCxq1Hr8OGdJuiQuVMbgPKfzLh4O6TlWt+xpqmsqEYw4zO9Y5/lggPYB02fGI8aLSc+NEsq9EE0B9SL7ELHF/sN8ZOcq8VSJ0sAsI+/UW6y6fcRY6P/FfmpnzhKJrJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 09:59:02PM +0200, David Hildenbrand (Arm) wrote:
>  enum {
> -	SECTION_MARKED_PRESENT_BIT,
>  	SECTION_HAS_MEM_MAP_BIT,
>  	SECTION_IS_ONLINE_BIT,
>  	SECTION_IS_EARLY_BIT,

Hi David,

It seems dropping SECTION_MARKED_PRESENT_BIT shifts the other section flags down
one bit. crash hardcodes SECTION_HAS_MEM_MAP as (1UL << 1) in
pfn_to_map(), so it now tests SECTION_IS_ONLINE: offline and
ZONE_DEVICE sections no longer resolve to a struct page. makedumpfile
only checks bit 0 and is fine.

Keep bit 0 reserved, or export the bits via vmcoreinfo?

Cheers.

