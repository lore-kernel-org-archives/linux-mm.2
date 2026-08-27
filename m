Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4233C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 01:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA676B0088; Wed, 26 Aug 2026 21:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99A496B008A; Wed, 26 Aug 2026 21:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8637F6B008C; Wed, 26 Aug 2026 21:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57B7E6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:14:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A42521202B2
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:14:46 +0000 (UTC)
X-FDA: 85145279772.28.B443BF1
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id D7DBD140006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:14:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OiW51Drk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=4ncienth@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787793284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBuM7Z8qJAkYuoJEbItk8rVmqNQCo+qHFYrg0x2wOxk=;
	b=NpQoB3s12hnz49cFGQEi2ZBv72GiEnyZiCetoFoSbZcXveYG7Ft4kAwwIH9RFd7/0qbkkl
	bULlRkYrBhkWqkbhm7Kt5tFwdZfkZEoXNiQ/zbsg3YPr5iTC6J0I1KfFvfCfVqRTyFh6Kp
	lMmT6cRbSbD+bJx/5woSs3aYC/OsyNA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OiW51Drk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of 4ncienth@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=4ncienth@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787793284;
	b=jA1gBWXzl5H6cCJgCHLat1pU3TGfJWyodm0muDGaTpXAUHupYkhtvFdrRdU5ixYORPEFjS
	ACK5uCBKhmF7v932KQkokShLpGFpBH8lbZTi37aQdp/oZkCvN8OmLuTQRXnU0csDq30z3V
	3nX196r4nMO5/dPKXSdNrmHZKs3+7cQ=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca766c1c9ccso1293370a12.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787793283; x=1788398083; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NBuM7Z8qJAkYuoJEbItk8rVmqNQCo+qHFYrg0x2wOxk=;
        b=OiW51DrklQQccpNNtGv8knZ8p1Gsju3Dv8YC1WPtH2Pz4AxluVDRtDnDGRtfxOeaku
         pgM0v9SpiOUaptLK7Qk3X0J5QV1sOXNfpjB7CghpXhzkkf7jDYabBbEEOZST692vU4Fx
         ttKvp+GwmsgXRkXG0a9ohcTTauSll6pCNCv6+Cp59g6HoXhuYfgF6lQijCQlR/tIOIT8
         eIn9PKTw7uR27Vv6At9XDsnDlSwI2mloDvqORa/fW7zTBA+h9aXfA+XDrERKwvQbEIGq
         n89DPZesaSvqbxa2nvIV692ZKO0lLgR970RKSvq1PazRjw7Sp4urAzV0oMjDCMczlSaT
         FBxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787793283; x=1788398083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NBuM7Z8qJAkYuoJEbItk8rVmqNQCo+qHFYrg0x2wOxk=;
        b=KAQUSO429B87pGdT6VNY03A7lPiBLY0910Dfd8l6BSfKPKipkI0y2y0FgUXvIE33gx
         o2C6Kv9jv5MZVGTwATIZ86hOM/eclK1YXRwe+KljiFFS/CZT17fn6U9fwkuRfkrB35ai
         DxzQ9YapXS/Ew36nCxcpZEqncBcmLKuYJcTL94Yz982XGzr+6NsVCvTcz3UYLs8jdyH1
         6eaV6THAU25czYk+3BUAhZ3xof+He0Wfp3g0nnszqEhjKckeziNnMk8Qjnt9LDnlIQdJ
         QqSpWT/8+Y9FxlCuMWsWBQRoNrXiG/D2POCgiysecNzTZU845pXY61Wj3fZ9L/mUNAmo
         XnSA==
X-Forwarded-Encrypted: i=1; AHgh+RqexS2pdJ7zNnJP6w9ClLmqhbRsWQoMRHuxTety786xFHyx7YDf/UvLmUOzrza1rQzJQBIBXpnBWg==@kvack.org
X-Gm-Message-State: AFuF++lEu84hPgPRkbu8ZerQFq8KyUyt8gYAeGfnn5cHvAjsbPYHQHMF
	lQ57pdo1Rc09T5JSzBuNBszshi9N3Ea9WbW13EZaz8bCYmgHCDtvcYOR
X-Gm-Gg: AR+sD11CHXKe+cg7qgO6Yl0yfuHlOymRPSvnTKv19my5E1a5tZ53+zXFQJL5zuzKnZ6
	V6aLFMyke/ATjygQ1QFov/WZ38uCFRkqU1YfPtDp3fWQigdLUr+8BxUlvK4FVz+KX0ClMeGtDno
	SqF0E09FdCKL1BuNTbnFI+D0UqkBwBRTu7bBODMKzW3iTdpP3mUkQVOTdpvo7QVBJMcyygl01Oi
	8QHTPfTyQYoGlZ4VlK2ckRATS7x6HtXaLsvT3pgLVGkbk3jjuTDOVvyh0Fh4QrhJcqgMFUpyMse
	lIFWE068ScCc7Mxu6aKYHU6LEy6tuJDsfMlRWeYD1bELCTtfSEXpy2PWsJYG8r3CmOQIQeIw4NO
	CqaIcXqlBD+HFAC0T1sloa8sEly+cpk7NE7vGU9gdEgbdrf7Qc+u5NDQ4fu/cE7jBergZ/wGhx6
	d6hhB2kH3xxCS8e6xGLDGXCNeOmQFmUnH1kJRmmgqN0Up0lMGwyd+21iErqc/3aCJVnvcztFbc
X-Received: by 2002:a17:90a:e70f:b0:38e:11ba:992c with SMTP id 98e67ed59e1d1-3966d4587b7mr23563979a91.12.1787793283407;
        Wed, 26 Aug 2026 18:14:43 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0fd5c34sm461051a91.8.2026.08.26.18.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 18:14:42 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hagen Paul Pfeifer <hagen@jauu.net>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/secretmem: properly account locked pages
Date: Thu, 27 Aug 2026 10:14:29 +0900
Message-ID: <20260827011429.1516473-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260826-secretmem-accounting-v3-1-94cb04399510@kernel.org>
References: <20260826-secretmem-accounting-v3-1-94cb04399510@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xmzx7abpehyeuuydy9nraerc7xoz6k1d
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D7DBD140006
X-Rspam-User: 
X-HE-Tag: 1787793284-523531
X-HE-Meta: U2FsdGVkX1/LAEoJxSEXZLwCpT8sknA1D4+jsBMWuD85cYaVKMLGd6QURf7zdu9pNtjxTX9Lj6Mv5SNPTqp92gmIwI2wGg75rIQItx+luNzRz2ilYjzSK6tC4v8mEgBRUYJqRZEErmqSK/7xkVTmoqqD8E3y9KmEKSWPYr7TJCeiNYw5yerZWo2i+wtU6cqKAi6MoFbSpb/Etyec1OwBJ+ERcZzoziZJ/ie1GFT0b9C/AD2z7y4hRqNnafvcaE+cHPObLL5leML4zZkGmrVvWzmT0gpOavl7E03RjI1c+cOOup+4nXkSM6AGkZ5CBGqu3CdWrT/ZdHC27jV4g1Snrg0drEw3EnYZWhVRHMYDtVI5vUNSGPwGiRm+9soXckAhsXDdWrIhl5gM8HTWH35ffFq8MbWj7B0xGjAykRf1tShlaatuO5CoIoDov8EOlnubAX5mX4kJhJBLwb4kWPqzpAe0ikqCOUumLGDZdprVi87MMK8q8aNW3oqJqBVMjuIbbI30ktrNvKNF/wIwfNGc1u/NZsGjGDofteHv7VGrwNINOGqJDnkdTAwgyOG6PkVCRT0e/JEK+Aera1gnOsff/Gxh6HK+Oc2zz8+fPOKFKXuVWTqbxWsOlYgk7vMVLwZUhObAE4RrvQNNmnfoxT3xmJPB+kVUeK1ZHNbNN31nFiGWlHonQes/LHE727XF1rEHwBiLDrOsWctyfsDd1YnhjdAwhIeMz6nAfktOZDT8pXybR+GvfzfcBLemVOiyhDGf79I59EF9PiF5poYQZ801zvVBAPErK74KVhN3Yjc+B7YTjgLYhwskt9toAgQZoMu4oaPwwN+w6W8nJjNKPt6AZ6p9C7KrrbFL3aUIeDCsK1AEGWY22DwHZSpYZZXc2gTgGF0wyursBaP3PmmPU5mipPmV7QgAjpEnhE3ot8VE5DsW0AeCMgh9ZwsrIzhz0Tpry4Wyodd7XL9v6jRufch
 z3c8oOIT
 gVdI+zNlapndWCprbuxQoMrXQRq+pdVzu8PTJumckzRXMqvacYDiQg2Di6uy+n23fmm/dF8basE3Pdt7/f+Pxlg7733y1xcEFcXaBkUK2ZMZ0vGnDQ2CpWIRF8kMKDL4dqr9+wLULXxw4tBwrhBHstE6EUUwNgXQuye7HAGigCcSZ+5jWepQQOdxFPZqYsSqM8JLxVaQEwJcweTeRx9IwAQvvSl0ziFE7pcKoa2lEWdo2ex1NVnzpH/U92fhBd4da1Q1/gDJfjCbcUS7yg4xqSxp52uYuk/s+1/dBTwluTzgVslRJh/wofl3ihg/1+cGQFkUWgzZ+ne2vDio2gyS0HY77eidDhMXdN3cIepQKV+/uK3t6N5Zw+pv4vVF24phljrh3KHdekxQckv0itDHpFq1J+vapXl5DKWLnLyty0U8/P4p0Xyp3QSq9R/NpaSrPm9DcvtIoYAiKc335moj/H5QXyQ0ZJAC5pzv8EZoSludBZAW7HFdQuP7CVvLAm2pPgnerOOenFdbfld8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

I tested the exact v3 from this Message-ID on its stated base with an x86_64
KASAN kernel. The supplied selftest passed 5/5 in three boots. My independent
accounting-boundary and capability/delegation suites also passed in three
boots each, with no patch-attributable KASAN report, warning, Oops, or panic.

The independent suites retain the mlock-limit and fd-delegation coverage
removed from the supplied selftest in v3. This tag applies to the v3 fix; I
will treat the planned separate upstream selftest patch independently.

Tested-by: Daehyeon Ko <4ncienth@gmail.com>

Thanks,
Daehyeon

