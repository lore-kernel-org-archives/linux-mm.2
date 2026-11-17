Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1EF3606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 03:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=v5vHpfOd
Received: by kanga.kvack.org (Postfix)
	id D951D6B05B1; Mon, 16 Nov 2026 22:54:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D460F6B05B2; Mon, 16 Nov 2026 22:54:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B9C6B05B3; Mon, 16 Nov 2026 22:54:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB3B6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:54:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9886EC02BF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:54:38 +0000 (UTC)
X-FDA: 85443244236.14.23B7203
Received: from mail-pi2-f8.google.com (mail-pi2-f8.google.com [74.125.227.200])
	by imf25.hostedemail.com (Postfix) with ESMTP id AC451A0002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:54:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=v5vHpfOd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.200 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794887676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5yYPPMuupwmdDkr+0YrNM2gwTmLnnxHM0lDOoH4/yWY=;
	b=gTFCqoGMvAb9+ksxb2E/yeBmNYMXnJx++EaeJFmMGpRSIZdVP35FNZoDQEX7aoyGofltNQ
	6RoKDJt/arvvSMiLOwDH0k1FVichTHxB4v0NgkoJVu4D4dy5txxnaGzGygdWB5HJVx4h3K
	JXjQSe5+pauha3nJia3fROFQqIwnPa0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=v5vHpfOd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.200 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794887676;
	b=Hfdtv7X8o44SgVDcGwqT3EPz18uIa5IlsDQ8awBBnKEURQ7knbemFf0zyI5IUE06KoyBFk
	TLQMSDNm4+vu8cUk3LrLcjjlEn7IU10LViIArIja2XEA94XfrGyp2+d0q8wAoBb7q0QS2Q
	ciV3oz1dFUt/GfBxxjGcInXgP1OCauE=
Received: by mail-pi2-f8.google.com with SMTP id 41be03b00d2f7-cddb56fa486so968581a12.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794887675; x=1795492475; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5yYPPMuupwmdDkr+0YrNM2gwTmLnnxHM0lDOoH4/yWY=;
        b=v5vHpfOdpSWHd9Vehh24b4iSjb3D4A0MVY/Hxym6T0sAhzS3psttPpIJr6hYRKvXL5
         AcBzlfKmepg6A8pG5xSyd5CxdPXk9Hc3QcOuEKE0Q9NboBB5Dl0mM0CKCqTL/j26rkbP
         Y9JjEqCLgNKoj6BE4ItE9D+XLeGVIXEH8yJfbA8xiexwa5rdLSgApV1XGdjqgHU6VoHF
         Vl4QmaDIlg73wlTT7aFqdUf/Qv8gEjcHj5F98WCCNkmHD8bMpyHRoqdh+KCECC9cTHEC
         OEVT/Fl8uRNueQvG2Quk6lLzOzCRu+kB8S7FmVGCipt3Hnlv1jYP0Cbfl9y51gI5nWIv
         OT4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794887675; x=1795492475;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5yYPPMuupwmdDkr+0YrNM2gwTmLnnxHM0lDOoH4/yWY=;
        b=G5AnF0Z6MvRUj9hw5oV5IkHxvr0lwa6rbclTl03kp4Yyylv7UV9VhZzWjK9SW2hZHG
         hhaoqXQVcMfM0smgzONIStmuESOfnnq4G/ZYSG3c0ElqozArAhRtBxIBT+KVKMbPYvTd
         VFWhVpvWwtOcY4sa/FibWMb/YY89eXCEP3A1c1LBQvjFVjrH+9Ua3I8Av0/umMmEw/+s
         CWsXMaKYIlqGbCkhQy+ufY3rhKPCmJblBQI+VWIct6tPg/f+dGdbxhGX/0RUz15PTvXR
         QGn7KZOy9Dmde2ID0WAPakxgdbQdHsTvvWWaE3tRKfkCJE53rQTK/63ul0UGtB2UDMPm
         JG2g==
X-Forwarded-Encrypted: i=1; AL+hErFnC7PYsVOgX3oDJSgd6yS/8pTVlRRi9CwLu0bo8To2rzBCWgoAWAQ1lUVJGlDJdWjE6YId9J80xA==@kvack.org
X-Gm-Message-State: APuU4Z8AUJy3SfiiGVBwaF1/30C0PKKPEka4BZFOeCF5Sx5hN7q3UNu6
	oQyAoK7x3r5uo0z85ZfOZqM4vq3RtjSq5aADK9tUA55hcMSgasQzyR81
X-Gm-Gg: AYBFou1H2JhoV9aaY+whsJqEoRvuyRkeJNSdtCUWGzJ6bZMPv+lXR2RFpRWq1DJ9VUE
	LLpIywdqDQyHrP5vsVQmDePfJvytxBLRwwo+BMYTzjMOp2A+9usGY7Fs8e0DyyBArOPGGRgod6g
	mDHzSlfMQhbGGWcP1Wn30zsFv6lldFGG2qoqEOLqUpd5fgdqlv/vMsa+MCQRJsoUVqP6Q6HRl/T
	xgco1A/sOvSqrsFv3VekgTouzWm5ZJa0SU2kX2T/a96TPB8Qah0mYjj9yUvsd1LreT42k/Ws703
	VJhjwrQGPqqQG9bMwb6kpGFuQL+56EHriwHV4/w/cyr2qWB/unf6quNtPbrYcK74NX2HXXa5ODV
	mdJ3q5PzDt/3Dsn0xdv1iPfBChllV52Pnn5whBcel8z3wWZjyDP0Mr2c6kI9HfKDeLz7Xju4Pkv
	wkKm17YzjVDgaXcpDPBIWoz5UWQiMB5MLeOL5d3G4s0AiLOme/O1DE5BvTq+QHYloIKprH/A+R7
	S8cu3PA/vgshGIeLMdcCvTBBOo2hVztSrBeFIbQWEtGXCJv7giq7NzFQMwQ4ilk5jjPQnLj4EGl
	diKYJrrbYcWJsvEJZOvAmUP+sClctzoytcH07XaGgMGlNYVrO884FWWffobo5tbdMVlPC4uLyGW
	T1W0SVWwXbiVKcB29hnrGJ2rF1ptVX9uTdDrR2P+8Rs9zPjFpJdllsAVW0d1EYg==
X-Received: by 2002:a05:6a00:bb8c:b0:883:904e:da56 with SMTP id d2e1a72fcca58-8beb677fb7cmr12261080b3a.36.1794887675077;
        Mon, 16 Nov 2026 19:54:35 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed263649esm4319559b3a.45.2026.11.16.19.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 19:54:33 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 3/6] mm/damon/tests/core-kunit: test
 sz_ops_filter_passed_last
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 17 Nov 2026 14:49:05 +1100
Message-Id: <179488734513.2.6285120857568566018.b4-reply@b4>
To: mattathias.pinchover@uber.com
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, damon@lists.linux.dev, 
 Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Randy Dunlap <rdunlap@infradead.org>, sashiko-bot@kernel.org, 
 sashiko-reviews@lists.linux.dev, SJ Park <sj@kernel.org>, 
 Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261116-damon-sz-ops-b4-v1-3-1cffe7227e6d@uber.com>
References: <20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com>
 <20261116-damon-sz-ops-b4-v1-3-1cffe7227e6d@uber.com>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: AC451A0002
X-Rspam-User: 
X-Stat-Signature: ueh64t3w3hm935rfhy3phwbwu7taoice
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794887676-349855
X-HE-Meta: U2FsdGVkX1+XBIGIvohuNWRXqPG2T8h7IJ/grLCaAskByPwmngUODKPO5JgGyIKVpapVakBujFX08PuQqo9KM4jYNqINvIDCkONFPh6rgEMlCLxzPuwKGh8nvB1F82UFL06N3NIJ0vTnhPBGSvw1eCpJ8YY4tiuqp7zVvg8VOBteYquDt0PIkExqFz/pUmP+8II3zhVwKOZuMJ0pBkaJ5A0xCcOfj+1KMJo4lTz6mQuRGpscZ/YjxX4QU6OIVdyMHwgthVtMu6OCEomW3tm7x1sU5ihHphDFarF1vKS/MtbWgHDICIgzSY3vIc+KeR/baxGGPL6IuKB39EiEKkuAL+KYVH9pfJF7shdmjNKHUFW6aaKuDQq42DcBtB0BJExgSH5ePCq5IApvFqOBawg/DmXMe2eN3bgkllGv/pCV3cPU3nnN941rIaa/jXeDj5X4bFJm5B2RsZ5InF9PdDMXB5W/hYO35idoDv7r/yQb3+tepPVYl7ZeIVD+8rMGbiZqV0yA2quhbinn5LoRtE5QwNZP0Ab3Pt1z1KVYyb/OIsc10A558FJQvHSMvboGM2yPPLpoW2dsmZk4jNljQHUVYJjCr0t3ZnCoKn+XoeeyDvSX/XF2YVoVsJmeaOCDPCqU0L8Ewj98AJteqaBNdwISr5i9NDSVAzW9oE38f20iQidnsCv69LYPSrB2eI9apZEmSkA6OTPuTDB3D7plF6BLxJkkM2h7gx1dlUu/3guCAD7L3IV2ZUvMAqx5oNYKkw4ztgObWnVP+rp8Obh4dfnD3D+BVKAvKH2nlqAEmjyR/WMeuwfwISdiD3rRofuvEKgQymCsFjf8O88YlnQ43LNoRrpG96EA+ya7/YZ6xI0ixldCgIB90k7UUD+rEU7zXemQCJaGADcPbztdMjdYGqfljsBTIWKwwXfm+2T2aDZhaX7NrPuKePZcjby0xtu7mEUvAjV5UoIcXlrJhZIsEm+
 8rw7/01Z
 tytyFdnpYr2ri2JK/kE7EKZysMVPEX59bsBiMdHXAMn2bA+Xuvk4RgZKqJjyTI+3d2+7hh3A8d5VotjrczZkHbuPHqRHvHLlqdtJGdhKdsan5lkuwpxqQc48vON/cMKoHkZ+NSDb1SsW/BQtgI2fBYk1Xt+oDgj3Hv1T82iXGGsb2gLVvj8IbZH/s2J6F/hAb3NzJ6kc4IzmYIh9JdmnDkNMjObpRpVaIgIby+dkjrD49rr54sSp5lSEkEvsiTl9+RaaBDEo6Zlr0QOnvUTgY2VlXcJ8fhrl6OMUUquhYX1OAWqhMMHOR05+FdZGILnTmKTifGOiLwlJh5L9mg4BXqfedvdFFhge5wOSmOwsdb3sVEVsWfGfElSdwt/hcQYaZaH4Xiyh4ikDgx++UfQx2dctYnhF1f0Y4+BkcAt1SCkTw/8F9R0rv7Db53HcuByelpA6YUINJqibuVRRsUy2TjM9RKp+oG7pqNgnX6p3CDbpQyOr25oIsNu6A+s2L/nK+jF2EPyxVDQ7jV7LndxDqPfn3E/MQSOorWbSC/u9kj+SymWZudW3iiBzofOS+LYdvJujy5n3kuXwIIz3Op6lh8Y7O+4NQxAtXL4yKl3VCUVWcbLQ/rQEDZjcHirbDPFI0xJCgR1YgO0vIVCAkdsnbAGAJZeDiMWiUIEVNHTHB1VXEPuqhL28J3EJFcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Mattathias,

On Mon, 16 Nov 2026 19:10:06 +0000 Mattathias Pinchover via B4 Relay wrote:

> Add a kunit test for the sz_ops_filter_passed_last DAMOS stat.

Since the motivation mentions contexts with multiple targets, maybe we
could also cover two targets in the same context, with the stub returning
different sizes for each? Checking their sum, then changing the sizes for
the next interval, would verify both aggregation across targets and that
the value only includes the latest interval.

Thanks,
Aveline Noir

