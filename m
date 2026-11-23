Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39556606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oI11FFEG
Received: by kanga.kvack.org (Postfix)
	id 48A816B05BC; Mon, 23 Nov 2026 12:36:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B266B05BD; Mon, 23 Nov 2026 12:36:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32BE26B05BE; Mon, 23 Nov 2026 12:36:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3256B05BC
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:36:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 819FD1C425D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:36:20 +0000 (UTC)
X-FDA: 85467087720.05.89D61BF
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id A54E440007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:36:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oI11FFEG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455378;
	b=K/PMXD8S5pTRbzvl0ojamzggTiL5If0ceETo4mkOdLI0JKUc2/TqQahUzs+lZ8RNFQF3dd
	K3kTH3H1zceF+XdZTE5tRVjzl+D40wwcKJXa4Twi6vASM5P4GUVD2OutGJf02NcTPOMuuK
	110Y3qyqQ55//ye3Iw8vK9qEPe/BNMw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=INKw8TwmyH+edyAwKvKRS19e6OnrB/i33L5so2wwomA=;
	b=N1bjvGGaYVIxJ8M9uKt5hSksmsAK+6tpkoRUqYa5Zn5aFyfyAHDMnAr9m7uwkBtmeqeasW
	0HdtuaY7Z6u+IBEYNZdM8gocVtHegC4fN0Z+nV7Dnh7907CcHbuPNNqQQWIUlc7Ge/n6XM
	RA2UJReRHqkqBsb6F17FXncMnzcYwaY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oI11FFEG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-386a9c93b4eso591750eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455377; x=1796060177; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=INKw8TwmyH+edyAwKvKRS19e6OnrB/i33L5so2wwomA=;
        b=oI11FFEGKy1Q5CU8Zli9a7SUW6yAFeEOHkyFJJql8LUi4w23Ta9bzWmndPVrknD/jY
         SrUQiKZ2iauYpOLpRQohwM3V5s+XgqsFsxwNJkRVb2l0CzaIjlGTUAqfqtBBRGplkSyf
         0N9Vp/OSmhxTwedGa4kFhobtulyPvxgUcVkIqbzz6Kw1t+iBmT+1wD8rVEmiCA85dCrT
         LJISEl8kvoZmojX9eES9Kzi4fqRxMpHsMk9YBmBqRldTZs2vlAg693jfwbqvrqjDRGK5
         KzFog0c/lKmF6tUlcBTgVQTM1TSiDBixfp6B/YYq78QJzGpkuR7VnXa6qc4izJ848ken
         MJYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455377; x=1796060177;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=INKw8TwmyH+edyAwKvKRS19e6OnrB/i33L5so2wwomA=;
        b=iMMTV0wr+9y1z4cr0H3sF+QDgOKbs3gx5t3mWcyerr2ZFpWq8sVIZqSCo+A8CYSZRK
         MDwQPG8jBwznNxabT+v4ninek6rC0x1RkIWka5Yfv9MMpf92y4xjueZAKEXmUEFanO0a
         gq5rccfnC7Q026dD7jaUzfjTvnUfReJ7kBXb5P3sulw4zTg371z1mJ68V3okAIKtb6B/
         M+QDqfNcFvkuKajvYg7XrIqs54RuBlz+V30p3mLfnKCFKcxhEe2ZDUJZk08maX46wopS
         yZJJQZc7P27eP6di3hMjc3HEmyLhAbqr03Kkf5C0mppRtwFvYL5E8i4Cdi2/z6LMr96i
         mi4w==
X-Forwarded-Encrypted: i=1; AL+hErHvdbgOui6xnthZJe14kYvySht2O50kIhbRRxhzdVixzBsoxfWtc/v+ZdQr+Fd1rCUvNYcSDZf6Fg==@kvack.org
X-Gm-Message-State: APuU4Z/mXqrkLQoXBWp/CXNNZjKgxoUyVi1WRpYDh7ZQsVjQHlKlNvum
	BdsapgTbWxfoUwUcw/cc32lljuBOQfRCp8V4PQSDLb/6WACu/Mkkh8rE
X-Gm-Gg: AZFdTZeLRkPm/4zl4V9/3RkpAUbSGhF+g21q45E0cXfegccBMQtQ9HWyZfbBRF/TkLc
	bTT3su+5g9iplzTdAcRmA6OaEon145qC+OR/VMmsYxbL4FTVCJhbILv55IRrBRlGvWSUxPrfsZg
	uzNjI0KlDAjS6esi3NPbdmfB2xXevhCLmok7uFPXsBIUPxzEMigg+M73AcUcIAEcyyoXnjn4ghX
	AiCaeWqBGCugMd14FjhxB6vLH51am+DPeArNL2HsFhrbKn/YM/4zaoXWdYv/NEoVkZGXDrQhGGm
	66RNiE39kaExBGoKmbNE3Sg0/7VdyHaVVq/x2qJhpraQn8B8yrMqYbC0p4/U/BSr/gGz2bbx60J
	QlQ4Jj+mm6p+gwbEuvPCwQ+807x2SDTJIm3ek+0i6Tm0I/2RUXG+8LCHm5MM/9s+Jj0TD2qNZtB
	V9C8ssqY0wqaCWI6sutXJoS0nybQIWSxAeyB/Y5gtrH/hQzHDGrbdTJwGSPVu3kBPwFG0J/fUf5
	obCIFoFxOThR3nCfAply1Tz8XK41wvSwr0Iw4LqZHfoIKmahbZAWzZ7tSiOaKuuU3e/+46f/oaa
	GFvQwy2Fo0aZe0FKaw3tv6jsiKOx/g7lin2r8gEfjvx7+O/3gd3gS82bOmMOoVAXjd2LAjqJYxQ
	MeMNykMHGQA013Z8k+2KeuFjkI/I3YQSPYkE3/7h1qO6R9xLcIMQ44JXtLPhzug==
X-Received: by 2002:a05:7300:f68e:b0:369:21a:dcca with SMTP id 5a478bee46e88-3856e9472e8mr12187873eec.10.1795455377225;
        Mon, 23 Nov 2026 09:36:17 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:36:16 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 08/27] mm/damon/sysfs: implement report producer type
 and state files
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:25 +1100
Message-Id: <179545256506.4.14417788905672907788.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-9-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-9-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: jsoc97xwk1tb7jkec1kfcq38kctgx58j
X-Rspamd-Queue-Id: A54E440007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795455378-66487
X-HE-Meta: U2FsdGVkX19erT03zhZ7VXngUdMv8Hd1oG9bTk6z0qWnIWweGWTRnoiXK7UY6jip2DtKNkgBiTI97C+4AlWJlpClXMl1LRLVEtR/ePoHUf89wmxH1ffUKao/wzFrQisDTbbJu3y8Pfp3voKQmLdPSVyIKf9X3CWjlJRoTv8/GyevQtGqiOe3QUfmPKmDMOyJC3VS+U2tAoXwgDZ1lpC/SVpIhORMNf9Q0aDAeJGm1PqkVnZSXB6r8388EzQeTLfKK7k/5GYxkH0mcqVLoN7pxp7KttzvPhw86nWh27DKJkCckzpxtIM65XTaAaM/JcyxrG1jH+hk6X+dCLlIUwuOZNx1GUAO2IufPyy2JI42uPH9qS7y8H4hYvsN+rCi1uzLX6Lzhs2kHaT1NFyvo79L/8Vnyn0PlxLbyoozQ33Zcze/uH9Fi500vWGZL6LsBMVwz2Rg/YTfH6kgPRliCfhQWJ7/4sjw9Rc2U3jluH/CHoaDUuoXEaQaKbP6y1w74FMFY3zZzM0RAOOvYAp2tfIvEu2ww1DkjnCExAOFs5qhlrniofmzj6MD5TjDsnjrs3qYkL15gzJDqOsspECK19bxNURp9odwq2zRtcyOzwcvOF+djIPGZbE0PbII2/2MRNChmBh5bNRYK6I9os+yC/8Ozhzn961bb+CfJTalt6iu6kjNtqBeYt66j+VokdKoCPAviswHgmdjh40jidyQI88xWRtfuv8Mxr2w5aNs00i0w38CuEOeoWkNl2Fx0Zz0av2wo8tHROmPEtlxnZIX6+7KbEELwNiI3w5DbBSX79eJ9mgouX1GxjWHkLldHn288+eBsv1koGkENXv1Dn/1qYgLy5MHLT1Lgo4Pf6ek7J9rB6YeZGtq6BdF55uBL3HXN7qenSAjps+MvS9GKTAIFli6wR/XQck7JWX3HWWoGvdY2ckFvkmCDBS9dSrc9DEY1f8GeMnniBj5gmtNGHL7lms
 R2+FWIxz
 WL8z3B3qD2ViS888O/SGvkSlrvyvz05niQZ9Y6EPhbfgTiqbkUylkCKiITl3m9hEwOFxBnYCbW/jqRjOIgBvD8afhKk97TqMEP4chwLb/ERj5XrJ+KgZtX9i3RVILtIZdYi4ChOO97iSukA/kn7pYxxcE/5BV22onJ/PIRDsWBDTTPXT3oBxT2jh6A6UX7rGrLXV8aoHeDexbWkBdvISqQovOto3tr1T7l6kzuJz9HVlSdiXeyWzFo8/dznCTEbWkfzaLU/jHtt7VEL7CqFQzE+j2FD7VOpL2R5Qk7O6wHjxnEC7e9XEMV3UIWSqcqyXMY1gzqvETixvq0CdIaos/lFgZfwjcc3CDH2ZMA0ghSJbOVgCORnaTKib9iEmoxEC2bOsWBjOCkfR7+MKWUsvstEGNOTpKULRxtIUOzEtHD3Ns9DEHQEgjr6vnhZ0GufJ2YmmpSZn2kDbrQbxZZcpX7VOemoXq7Z8jaBAUxKnjk8bO+RdWjUdFlEKX9/xkpsTwVWQxYh9sHcq5JkTF4NKW313Je577gMzrW5odbDEL/mKg8lRNfztR+g6AMNDkp71uLX02WT6nhLf4Gbn5ksPrzK5t0GmjunLnNqA5AItfNjwD2bpq/9CWhbAgiZIWVY8rPXRnv6lS+BDP5kxTbIPe/C2usvxNSzfmtpfcCt1w3WgZr49q8lY7ei7CwXSTdGYK2zC+KucOflLpiEYqBxupU5f+j/Zy4ubinsxzW08y9mMMR5zxgQkNq0PqoQD3kBYgBiEb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 12:59:52 -0800 SJ Park wrote:

> Implement report_type and producer_state files under the report producer
> directory.  The type file receives the type of the reports that the
> producer will generate and submit to DAMON.  The producer_state file
> enables and disables the producer.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

