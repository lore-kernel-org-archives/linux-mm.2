Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73441606A321
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fAJka7BV
Received: by kanga.kvack.org (Postfix)
	id 760E06B0171; Tue, 20 Oct 2026 12:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739046B051C; Tue, 20 Oct 2026 12:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E256B051E; Tue, 20 Oct 2026 12:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5326B0171
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:12:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B833316029A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:12:24 +0000 (UTC)
X-FDA: 85343497008.11.00952D5
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf24.hostedemail.com (Postfix) with ESMTP id D53E2180006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:12:22 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fAJka7BV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792512742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ud9ISIbyr7bf+XRYkVCQzyTUHoKhr948RmgOVkz5o0U=;
	b=jynTxzX8BQT6aRgWUs72ok00iEy1V8fQt1w30xcWv9PA0wpCOoWD1ol3p8/390qi26nFEm
	hZPyKKNwAwdJ32nKS3uYL/h7o64tLyozWphp05UiT2bY6n9WHn0/MxK7DOriUycMd8txcA
	U3lvfeNuvZUvn5QutuLMnIsXeMk1clc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fAJka7BV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792512742;
	b=aKTqOQMGpHs/guvingSxoB1RlDSHnBOZpsceFVUi4KAZHIMItKYKz8ll6W4Pu+7NIuUKjG
	+RmZOC+XpIiBTBrRAGi6ALXuvraV+9QdDKTDz5+2XIFl4LkhyMy8zVgaDR8g8lmmbpHRrt
	e0pC/XNbUht7Fhu+25QMaEZ21wt0Jiw=
Received: by mail-pj2-f8.google.com with SMTP id 98e67ed59e1d1-3ac6fe4aff0so2118695a91.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792512742; x=1793117542; darn=kvack.org;
        h=content-transfer-encoding:content-type:date:mime-version:references
         :in-reply-to:subject:message-id:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ud9ISIbyr7bf+XRYkVCQzyTUHoKhr948RmgOVkz5o0U=;
        b=fAJka7BVweWVGa7EIGcEeUpEoDN5n1CYnJ3wZ33yGV0PsjeNuduBLw0/Ho7A+kbJl7
         k75QyHM3y2uS4iBDML/BqiLqBicUd3W8seir+k40iFubc3c2URs6iiSokTgwCn/YAF8j
         q24+/Je8ROYxbB6VO4myy1gETjusQHjpt6BfUCPN9j+PJ2tu8z9wxpm3BVMhn9ndLlMP
         Stzhse5/QZIrQriWLTqUarVAE7UqGs/5Ov+RMaesORoqsYDxU6Nfe7xrTtDu/n2hNqer
         ityrGxKsMRgGoS2A3sPw2cPuLr1BppjOsnwnMwKIzJIiSrh/N1CdgLPDGvfURhFPbtIV
         Ap9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792512742; x=1793117542;
        h=content-transfer-encoding:content-type:date:mime-version:references
         :in-reply-to:subject:message-id:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ud9ISIbyr7bf+XRYkVCQzyTUHoKhr948RmgOVkz5o0U=;
        b=RJhPYdD87nKuOK614vik58bBD2zKw3htm9+Yd9dg9w6d6VXAkq8zXn+Zy2T3kejX4U
         OHjyCAwb3sO4I3wedNK5espeDd2eoreJ3cC/gvLNHRbinvvTA5UtqjufnPMWIHIVzFDX
         n9aS4lrMTIuKnOUSNHRo0SqvTCj7Pl5zbpcffHEW4o/29UQIN1OI+6b+z/j1xkdHyYhM
         pIN4v//eI6jHTJnN4CFUczfes2Qsc8uPiw94UQ7G/r5o2u2ZsxYwyhOwN+76fGj6/AcS
         YbxSHh/sUgQOjwv4LW9uBziPYc2AVTB82MhYMbTZRVYX+yP9wKNi+Rfc+FLaR+Ijz0xe
         Eofw==
X-Forwarded-Encrypted: i=1; AKwUvBzx1WR6injK6pN/jhHEeIn86B8CsM7fLkzfb4olxOWXolqxCGDdBLXhOK/i6WKai2FG2SirSrKYmg==@kvack.org
X-Gm-Message-State: AFq9FYIejHEGXvt7ShbAREya3WKVwaUIysb+he/+T9+iLvrdZHYUTumY
	BDT1uqy4P2dF5Z0R4W3HAfT3OBt9I8GxXPVub90hQNn5iFJXsKsG81vi
X-Gm-Gg: AYBFou1r5CTPaP3OLAWC48EcaBti6MP/6tpqQys7pisMIMvW5tmHZEZWNq6a/5QR2TW
	bcnaX5xLPexWAYcw6czh8lH22Tw8L0hxSJfFgJSbzQbMcJhi8uVFn5ed9RIHqhbwb1eS11tAigl
	7W+mYqarvRvS25eurMEEKadHtaBjlz+4+rpRuhObGZ9hdpBnqwATAQJoztAaUW5/2yEjrC/9YpW
	g9CIgwgZWJZJ2M3Sy6njuLf7nkbqAqh8Kp+7zE4XwEXR1V338SbO6dXyPjDvhra/0OuOOo1Ftmz
	4NO+gNDihEcfMK/yul3ezzymRYdz/a76e6NtlTSr7I6UgZIMHzy+ht1IB+Puke0707tXMlL55T/
	0k1YV/vCzml+u6Om2ChogiL3PBcXzeEyT49xGt2UGxtO5C+SHgegk335MGom/PWzzPm9uY4gJI4
	UXUl4LjO55Vl7WyYc3dY9JsykV8GhtSpmV+5Rgt5d6QUKBohJwinhUrg1M3UXZ0a6CGtULC3IYK
	BHr9lkMAdU6bx9Y+aPNQgQp+18AgNETHzCHom5qhSDYEPDzBBR3e5uDQHWtUir5iiH22HFuLAtD
	iA6iY5w=
X-Received: by 2002:a17:90b:51c2:b0:3a4:f75d:d1a3 with SMTP id 98e67ed59e1d1-3acef0c891cmr10365935a91.32.1792512741637;
        Tue, 20 Oct 2026 09:12:21 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad80219f83sm240190a91.6.2026.10.20.09.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 09:12:21 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Message-ID: <179251038772.2.11838017412675823324.damon-filter@gmail.com>
Subject: Re: [PATCH] mm/damon/core: filter out damos address filter-split
 failed region
In-Reply-To: <20261020004119.106690-1-sj@kernel.org>
References: <20261020004119.106690-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 21 Oct 2026 00:07:00 +0800
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D53E2180006
X-Stat-Signature: xrtzeunymki76gud64j1e5czmnzyb875
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792512742-666314
X-HE-Meta: U2FsdGVkX199Sd7O1fxrDf2AKk76a+nvM0Hm4XL7pj2+SNnJS7Zof/7G9wV1bPtPd+D7Ff4ancmHzVdSbmmq8wXAFQOnRE/KG944ChXmsQHuoYwBgnrccB6CvLvhkryOtrjvrqkzWDMy3byFr+J0IfpCpSn1B3eIpfSUjFFG85K04nZly4B41xIArU/w8axK+fXK+4lNBqqMfwTy9kM1UyYbQNr+hSUEke7X6P2TRR60D+RfQkR2K2VCE6dcSOEXq+mkp019qCcaws1s2L40/PsApNRcq6y5DoZh9ipEfNEJ9xHeN/A+313AAeQ4y40gLzZZsDj7EWcb1gDOIaEWJTk9jc9b19pCB6PwkucT/nmF+3p5Rd4+Of+91z2ezhpcHYrjzElb121dZUP9isOEFdMgL6NSeDKx0uK4WCnYkdk7ZR0lfclDVBKQnsSlnnc+TcGbmAW84n+ce7Uao01mrKqv1pG53oW3QOyF+vek0PWuE7wEhkdB0nWh2g5d5m/5IpC5M0OcjuYseRRBuEijdXIrtoSVVEaXj1N5wI2IzGaLbYpRQHVuPBZkDpaOUyRgdywILWTXQXA4qoZTNFuSZJlxET7weFkViqjPs8BuZdH+W3MALjjzkl/OykiG41T0drolXKvHLTOp5GjiuYzid9RZ2HYYGH9+HnkAgYE9JoyOweY7PA+4Rqdw+DcY/AiTrjqXJ1FxlOi+eceM+tsdnKSHKKW10a5PMTKarrIXv6DU3iw6mSmHk8yPzi6UFS+FyuuQ8D1d1aNAT9sSg/iQQMYYsu3CjFQpcNNjzqKFtKp04HMGqIT8PCWyQdZqHNb4B8V+/PwI/e10rBTxt6IiaW9KrvBDkbHUH94YX5EaLb7qeHGU96nM0h3tZaOKzfIuY7/z6lJ81i5jXeLJJYSXna0glVD+lN7asXC8lfcWrxvS48ci3IFwGUUOzirjSMtB2xd8S0nknFBhvNskRQT
 7VsdGmMv
 +AFkmfDnrjPGOwpNp5a9Xvsot/k++iG2h3UcX2XV7I51oED4/A54sIcw8if02GxNo3TIHEJF2uMcZCTuwxJl3Nh3tirpdKsjyzb0P6DvH3DUEpL07tqp3vt3SyDaIF0n+uEX5LYjBa2tcyfzR0ZvCz1BlAUO3yNV7yh/21PHtrutt43sC8AOREKWxZ4tyNc+rB2a8EWGZAsHxWG4Q0TLIE9ONljZiPZiC+3hGUpmYWi9Jmy8ZIE4xqa9aM+rWfttP8Y2LFDirJIBi7VEVADBNR8pev3MLvejEToCYfXZyezrDdVlEbzBOMX6/B6mwbpmC0+coO9uxL5cN3BNlCNwwBa1g+PUHAwgqNsyFIidgAV47hTzW0l5o6cFl9jAv57cHneQBeFxgq+EJvy/9zWEd4Q1icee0vMh4eQ1dYb/Z9LAicWrYiNiBgncpDtsbdqfNYagv1rnmGl0IH5MiIj7xmQvFGt2vMoH8C52/pX88q4jHoL5yGSopnG3+tQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

> Filter out the entire region if the split is failed.

The Patch looks good to me. I injected -ENOMEM at both address-boundary
splits on x86-64 KVM and checked that no action was applied.
Normal-split and filter-order controls also passed.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Tested-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

