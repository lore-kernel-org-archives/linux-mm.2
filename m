Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8739D606A334
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jkGf09OT
Received: by kanga.kvack.org (Postfix)
	id 52CA26B05B5; Mon, 23 Nov 2026 06:59:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503E26B05B6; Mon, 23 Nov 2026 06:59:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9D46B05BA; Mon, 23 Nov 2026 06:59:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CF686B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:59:51 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82660806C6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:59:51 +0000 (UTC)
X-FDA: 85466239782.29.9A7E6F2
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id A846F14000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:59:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jkGf09OT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435189;
	b=KkFD3rNMsa+F79a8qDd/lUWu90rQBNRkKaXCLozwiciyFFqX+W2iZ2X1zWBYt6hdSPw6ok
	ZTbxF/hz9iCtfyvTc4VcuUpq/tMgeZl1G+Tzrc7Sm7p8Y8ISXbA+VaMg9CV23wofrAQcnV
	883FG+dqLC4vR4R9DjPGduvsbFTKIxY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/NLDk1vGGl8xgKid79Up0qMX8cqYam42gWr11Gs008=;
	b=7sRoggjHw2fP0Rc6ozHzIb2N+x6fWjbmfcc4T2ndpajNZ+BTe8TXrpwvtNCoOd2HVpjzV6
	BjK4Obn3VdEiGDJP/HhCTWvxvdVz9q0XQK0JaHGBO6WJmdxSPo6Sxy2yFOU2LUtbY94m+7
	MLamBLjY7/Ht1/JMuRYDuhktvneEm88=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jkGf09OT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-38190551625so6654702eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795435188; x=1796039988; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+/NLDk1vGGl8xgKid79Up0qMX8cqYam42gWr11Gs008=;
        b=jkGf09OT7VKFKhaI77CR8/tDgL6kr6XSHLEPsfHRJARvL2wX0DcoghxKGf0y7XmomL
         wXpP1aLPtg6LCdDvKKN/2no2gOBn7NY6GjyAY0jiz0pnhwiFJutBlvi66UjMn2m53msb
         rtBqp+Aqxs01dSSPKsonMo5+KWxGUyejLhR3Su91/lw/Yl/tMEeHG5G3qXh22HDXduOP
         vpTUkgrQlHY238bECge7BNwYb8iKRhv100x5CkTZCdrSccyQk9u/fdKJQqrhJ/EMEXfP
         BcQ/BK2Mw6dP3sohFTt9JtmpLolSu7cJgDC5bvB384uUXwLzqaRmbr8jASdOHFX/64aM
         NA8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795435188; x=1796039988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+/NLDk1vGGl8xgKid79Up0qMX8cqYam42gWr11Gs008=;
        b=dUqhb44WGy8VJC4dayytEHxicDmTc36cxHCvRm6qMy2v5a9IaNEp3Pk8zymvBb5j/V
         rGQD4qB6RqQOlcIsqrmmJA3mP5dk/QLRd3QnxZGZ721g315LCVNFTMOkwAq59vPLd1TI
         VYqN0WWyvCBMDzI0I8SnIJoO/4zEZvg81cPMThNVRkSMWD8tVZ2968oAFTDG+VXstHtO
         3RwctxOYVWaEcM00zIDeYjT3Lxx4lwci91BRXSDOQ+iYF4EkQ9336Q9E61opzgCHe3iQ
         UgONc2QHz0ceCbakNV3eLAK5l/3l/DrrDrVfw6iKhMfbtjSBAW36nfGMoZrhZXsnBVx+
         e9Rw==
X-Forwarded-Encrypted: i=1; AL+hErGQilN/Liw1IEWjSVZk723WQK5u0vLAYstTOA3gwlzeXuFZ7W5n4hA5ZQyL0BHAmMc7byqgXbwJzg==@kvack.org
X-Gm-Message-State: APuU4Z/V+QLUxEA0OJxuMbDlBYUzRpLzuFExyUDFi9sS1i1wQYq4+czI
	PejM9DThUKhecQjxFlyoWqC1QQrb/Rf6t2GloaYsBUlxaPrZ3Y923j0t
X-Gm-Gg: AZFdTZfVYtRyh/LA8TWHCLWQp54NOZxy7C9bBTAumc23m+2XtvKm0sRdvWmuO+SvS4V
	GHHiAyXojzi+LgRW3+TuGsQIOB6zBQwgL7Ejw5cXW6IYj1xBAtOLXNi5Nwz6kVeYurXnPKRBTCd
	07jd750Q9dOIc8grYyok4PWF0tp8qtSfmaaWKD5C6pKaukjzd16cXSJnwaZ3h8e0NmGrBv7n4o2
	XOyS1qzhc/EOyyBEA1Wnf4OZfJJ949irmWaxLA3cWcZaolMuedpZ46YrAWM0jypERiAxr8PjJ6p
	lEkVy+AXwzwjKpSuh+XyHyMIWIPdaPp4+xL1wcAhhMOFC9aXMmuqWc0pHy6KESyNToOax87Jlb7
	DAVgaLVSDSZdpHFVwzlAFywtBD3X0RGG9LDvKs4Otzx9IcYZ5SgRvcM4NIkb/bc1r4YAtoAYMUi
	yzU4506CWunqoIOC1Dk1LxBERZX3EG4rlI0besi5vhZvjd5Kd0zUFgCOv6IflxjDAWTaGtEvE2M
	3u+KEyIjUJK8FvvUDfsi0Erno+zXc7//t1DqD6s0g/8Rd6cJHpOBo7gDXac2OguOkGQImXvUSgD
	A237e0FjAiq8vwy214tvE32EVO7Ex5GyOxuWtL31nlnbJlYAgyVryHf71/AJvJdml6VA
X-Received: by 2002:a05:693c:6010:b0:385:2057:eb95 with SMTP id 5a478bee46e88-3857073f2a3mr15247386eec.31.1795435188390;
        Mon, 23 Nov 2026 03:59:48 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567daaf70sm37620267eec.28.2026.11.23.03.59.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:59:48 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 12/27] mm/damon/core: introduce DAMON_FILTER_TYPE_REPORT_MADE
Date: Mon, 23 Nov 2026 19:59:33 +0800
Message-ID: <20261123115940.9068-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-13-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-13-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8c8fyewi68jatou7f9wohkdaewbiqjhq
X-Rspam-User:
X-Rspamd-Queue-Id: A846F14000C
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795435189-916268
X-HE-Meta: U2FsdGVkX19caSpFPpwpKQODOxrT11wbTrfHk8aDOUO0ODvAbfmcDWywOQT2eW2pU069bc3ylzeuOQ9SkxXLIw3xcAhgm3r6qY030stcft5LOjvwXe5bXN1pZEo2B6Vwndi1Z4P+jTCnjkPGBICMvFURRuWpwMcNYoVHYFy8QwHtFyMQ2SfSxHukxTeAB722hGZ/ZJLHfbi5an0mEQSIfqOZMf4RhRf9mE8pCnLluU4AtsyelwOws9nyS59neyVLZ4UE6nARU7JhMbga5dn14hHCXX3PtNrotIau2sk622GZDYWauBQ/aVVsZWazf7bco5SLoXWE6CYfWJA903KExezm8Es3f7rTy9ZT4JWUaqQICC1CdDx8VH4KHaZQwY/6QjITlGatjG1RXoX4RBfyjx7vB/Ys2ZaN/H0jIhmBpi0+hbf1EcAvd0zyWcgKAH7LajRK8/8BryfM6HNNEYlUfuD+ug7/mXHyG7bNKwCJuQKAG47/t9T/ZQlD4X0FkZbrR6STY2DmUjK2Bwjx5B4LtdWJRC9oDrHJeTlDK68H58LnsAAMstX/HyK7gtY8Iuzg4CiFic3LsQuh6Hfh6vRKg1lBMX7rgXd1X36obWdheT/TSWnAHfGJtqoez42grTCK/u74UQwqK5+SQuJNWt0XBBQqFuas3GISzVL6tiw0IDerYBeRPtKlNCZzvTRevr3jGvLsZRkD9MyXKCMkqs3rFNZqLvmdOLV4ZEvwHGFK3ICd9mellIzno0IkpzstVpjLoF5U9J3yVg5Igk2qL3IBP/QBlWqlCbV2I4tVrqAOyaOw7KTD6umaX3/jkBTpybQ+So0MZaf4P7qatw6j5ukE6GV3MsEateaQDNu7Y2BCT2wegGBX5Xqxip9QqGejFeAcvZBcNn7FmvrXjGKpmTDsFCy/x7x2zZrKtQyCfp6Qxv698a87MJ6rEnFvFLATdl00LFkCC8SBEMDzSxMBIXs
 CCzCIOLs
 s3wzN1MzZEVaETvXmq2FAGaL0815sKghAhvXb2hJuGrvK3RY7JpVUDovSjNJk+5waLU6qKnReMNDqvNQeDkLXLe2UvnFl67PvF55SKKgqocfcLnTcDYTHOu3elBjzLjKgW321N3wxt/Kj1B91r+x7ovasQWrvj8i1rxw+0iOOQNaNyttOrMWccbOb9sZ4nvQYXrM2549zGou5fP6m9rLzoKtsiIalPF8QPGgvJY/VPuQUNOd6ksdGzOtKzrfCyecs2/lEkSHJYO5ZrIASrFKnISL5LTPg0rSN2eas4VUOtMl/zoJAB7MoQBWy1ys/eeUQEsgFlXmSkJB8n3vn6ah50Q8ity17ht5cNdeY4FhBYgOO3OtYSkTm/i7rj3sByakgym1pGyrbl6efMb34ZT91TBwGgeD157qENNOnsVTfF8Wa+cCPpl+kKqnjpJ73eZ0+J7udKWOAwp3/XZ3a2HGRpcA6KEONt8XHi0vCg4U/GaHzFFOwjx0ge2j77G1YXGRa01MCpEqAk8R1J+s3eWc3OMld7zNMqFo5PLoDPQQdoYGzrge+uuUghFbVYHnIPtvkAX1NuV36H6YBJxIlo3oW5WXqalizAuZjzHZUXKO3jYGC13X+pmBxtM3ndrB264dKfTXX0Q9OV4+vOCuuEkynM888WLBRQp2uoQH9X6fptcmaAM2ebyS44sufDu6+7w82+m9o++RF7L9hhuwpwQvkyI1Q0zHBuvPWxnZL8C4Vgumj17g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 12:59:56 -0800 SJ Park <sj@kernel.org> wrote:

> Extend DAMON probe filter for the existence of data attribute reports
> for the probing memory.  Define a new filter type, REPORT_MADE, for the
> purpose.  Add a union argument for specifying the type of the reports
> for the filter.  Update the new argument for the new type when new
> filter parameters of the type are committed.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

