Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FDB0CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 15:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D938E0087; Mon,  3 Nov 2025 10:53:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3ED68E0057; Mon,  3 Nov 2025 10:53:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54288E0087; Mon,  3 Nov 2025 10:53:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B4BD18E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:53:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 674B8160187
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:53:54 +0000 (UTC)
X-FDA: 84069741588.19.4EF8DC0
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 84686C0002
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:53:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nrMdOou4;
	spf=pass (imf22.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762185232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fLey69Q1yRBIRmkA9w/tF6nJaEmvXdViphT1MNeupw4=;
	b=niFF1A8fVw4c27KBgx2yxhDTQGUQE0RsjoGyEzlr0huGx5v5op1HNLwwMSF+v5C+Fcrg3J
	YbEufPh3ST19AOKwBpxuqxlQN+u1oEQJyKthoBxgEdJ9SEIWsV3KjZEeriO/+R071ybLqQ
	pDOnJR8NpiBRVQNNN3ZyUdEGuGkGUjU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762185232; a=rsa-sha256;
	cv=none;
	b=XjMQlLp57ckw54zOvjfp5nDuTvb2kTINUr/iJ/BE8NFmVobQh4s+eDvMY28i8bxdUfejWM
	iux0CQbDtaduB6xAXNbgqiq+LUGTskxkN7C++Wr6Gtsfu9BjzGASfJodMuJud3YBfviNsj
	hhHPGZq6xqdyo56jGhjm8tvVBWd+F0s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nrMdOou4;
	spf=pass (imf22.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-474975af41dso34418925e9.2
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 07:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762185231; x=1762790031; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fLey69Q1yRBIRmkA9w/tF6nJaEmvXdViphT1MNeupw4=;
        b=nrMdOou4nPW/vpgt027gnIYH/eDhV09PiEgfqCxQinpApTvT8Zpp1roNM1SCfKOb1X
         iWcsodme4TUCZGYGJ0v+wRlu5b/O/sm+anRxtnnyyvjkC6lAf9YYxwFtoWoOKq3XCdI7
         /8/zn7NlI9Goh5gP6wAl9bEtY5D6zEyva1ze6cf0p9JfPmmZwPUlAoH5b5R1N2Hsa+rs
         xPa9GY6ShmXcmqT2FyF11HnfzOFnPDp0S1DRuHFam2bvFSniGrFH6/R/bvxIHJjICJ6F
         hK2IZmN8wR7p9QB6NVvAKfVRbU4hd2lRzqju4q2m7J3ScW7uXp98BofJRL0mYuH0F/Wn
         Jhwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762185231; x=1762790031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fLey69Q1yRBIRmkA9w/tF6nJaEmvXdViphT1MNeupw4=;
        b=OAX7xnhbRsdzabNWETcaxg2DqXU1gaSBaW3CRxMldsxLAaxEb5pHFXfH5KYWIIKZJe
         oEKZux1CjWBIWon3qeGTzCLKmUFkSI+iY7BVkf2XbJJgUgBm4HKE1SN6xAXZx3qlHjvJ
         /oj2a/cPtxCVLVb25pj5nDrEBpFmKFKz/JyTCb9YSZfYXGoENJH0kHqzDLcXVtJpkUi6
         1zl8VfzasLOCowX5jy2Pz8eGiSPucvDGzC658rDS9M5f/zyvbxiPC+63fKo9lTRXGvYn
         LXqC+IV8qXwyfG4aFsl/uQm3LMqy8Zx0RsWVtYdosNG4IQiP1s/f5Ta3ZGe03pcWH3Lr
         1bQA==
X-Forwarded-Encrypted: i=1; AJvYcCXKs16+ujQsySujc4pIc5lh+HntJDeLFr8WVMtqEZ37zSBZkoqGPqBfvfwIEtmuwP8MvftSDRCnVA==@kvack.org
X-Gm-Message-State: AOJu0Yxk9KjDjFGtuYGUOnveu+jLM/1wIPEW4weOl2qYiht/VteblXuF
	44UZJoLtzxyxXIm5q8ga37V9+nC9oXnsIQiM3sltjBmOe8e7wqvZvtam
X-Gm-Gg: ASbGnctb/w8wWjZR+MozyWOEBRG2nhUYXUts3Una3aGQfEz5ygEpZyWHUWE6nFVZKDw
	RxoQ08RjZCrTHeMB1+pkuZiUrdTZXUREzbgSXx8XQmeGgVMV5+A2Tyi2nANipmLaaghBqQNWgpX
	cDHqZbnzZ/mglocTPZ6jCPhAcIaG4I8fTdRvvuFy/s82x5aYmZqACPmvS8VlZbk+O1Qs8Gg/3fz
	yrmpvJp0VFOesChjuEVhv8tBBO4l/sQ5BHdjWJLQthDoNWDt9sMkiT4tL/gRF+Gve+zA6RZScwn
	evlxatu6iOb32f2FAvQewLj/mE1EnzycKFlfPccKiFX9x1zqlQDEGQTjMddc7jyg17i76Y4+QeE
	rcfaJ0ljDtJzp2o4XMNgp0C2fFLf1vX9NDyyrJc001yrJvnCnzy0mdtcwW6pvsM9MdACMnLec
X-Google-Smtp-Source: AGHT+IGy41LT8aj0/Xvj0W53yZvKvDn5c9ABQJxOklSZONmqbPHs8HNDAqrjQAZba3bO5xPU/Rodqg==
X-Received: by 2002:a05:600c:3511:b0:470:bcc4:b07c with SMTP id 5b1f17b1804b1-477308a8f36mr118541675e9.37.1762185230454;
        Mon, 03 Nov 2025 07:53:50 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4773c48de65sm161908635e9.1.2025.11.03.07.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 07:53:50 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com,
	agk@redhat.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	milan@mazyland.cz,
	msnitzer@redhat.com,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] pm-hibernate: flush disk cache when suspending
Date: Mon,  3 Nov 2025 18:53:45 +0300
Message-ID: <20251103155345.1153213-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
References: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 65oo97kw45ru78ohd5rcxhb8jy4dqjwd
X-Rspam-User: 
X-Rspamd-Queue-Id: 84686C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1762185232-748141
X-HE-Meta: U2FsdGVkX18WIP4ebwM82TrJ0JMtVklaxHEeTccfAfAUrsqUwOVSJ/Bzt7EJRG2jspe4JU2NE/OZ0uu8ZCdcuoJZCgMqfCyxGuGqk3IpbGTJJfGF0Ul14KUOfWSC6LnhWgvpKYP1+h9aNm5cu8Ioveagx86BGdjaF75ND6K4ZFNCgPC9TOkTLcvKGO0b5Ym8SBR8lA9rVioJ8xah7Kr5uzEqMZlNY2/ssegBXKW+kipoutYh6+k1p1OUBRZusf/H/4U+3+CBgFLRONwVN2KrLC/jwHs9m+NqIResO+fZ/GAGVaBeSCtNUVr/4LDefPbPQMVtBI5tmygUMMJxN4R9SHy0X1qb3VawkI/eUTwen0V+Cxk9ytpYvswse6GDVQC40lC5KuLXGyjKKjJPtjrmXXmevGNkzTf+pDyixDd9y00JRwn6ctol2ZqD4uzdMEIUb2sjTZve5XM25OkMNrnKPnk6FjMN7Tp3KwIUUbImY3EWbGH0Amn5okTV1ErhCT4a/+L1xLn2DqYPwtTe6AEZDFwf/LTSoZYnZtfNWBhH/KbCjkkpybe8w6EUOfG4iYgh/W64doygCcmq9VmQdxCVlb9unNjeOSgnEfoD/mTtDRqMFT8K8JHb0MF0qgZ0sC7vX1G7GqWXoNzpBzDTsqjFPno2qLXbU/UDZs/Mo4izOKu0M6DwhdBTlsjJIFrOGy8Diq+pY+xoUWLAMILjd61sAcBKvCXsfVsaFPv533X40bkBzBZNbifGMz+UZaO5dOq+502VBOc1Yd3HQ7HcxgpfTBwK5Q+48KFIlq3zYOztsk6BJ12xNiLF5MG9qUP8yNn2ywWgaIr0wmvCkLZuTvXdZJ1dP7issrwvsC4aBAw/2aftHX71wTI2HEMoOXMpZo+L2GDTNUEziObLcA+Nwq+pQN7KJAvEK5nPDTlxvXmDSPx6Lo1FHF8hvMVH1y26JSd//Jx8FbvoWPA7ilNx5PW
 5N1pYaZR
 buqlzDgNiLnmuiFWdbXPX+5MYlFEzmY3yWrniIFJhZjDxo0NxwGzLwjH9H+Uh5VVgNxmfOKRJIG+m48WX6dtGjKOJ+Vc98sxi20Ht2bvvI+VMeP1r1N+B77/bD+I/Ai7ODrs36fM/pbhYORh4LZmp+Et+gOLiz0Jo7cMSWZOCeE3cx7v3O6K4CfMRgrn9nPjgSkHNvVsWUVxM8Oa8wX2MYWyhSS1LT/xuLtPU7jf9Gx/qAhMIMnp5PgwY9p44+AbWaHxMHNn6RR4BcXnDGMSXCyjVMy8erlHlrnqmQojBJcRgWg7Pbb2SurSAyDC8O+xjwvwQuMoTr6JqQox4KUThtdeNiR8bWipmjJg5Tux3zlWugRhAJZC61gj9slwsVGnDNyf2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mikulas Patocka <mpatocka@redhat.com>:
> [PATCH 1/2] pm-hibernate: flush disk cache when suspending
> 
> There was reported failure that suspend doesn't work with dm-integrity.
> The reason for the failure is that the suspend code doesn't issue the
> FLUSH bio - the data still sits in the dm-integrity cache and they are
> lost when poweroff happens.

Thank you! I hope I will test this within 2 weeks.

-- 
Askar Safin

