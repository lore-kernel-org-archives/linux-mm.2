Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA7CBD68BC1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E52B6B0005; Wed, 17 Dec 2025 17:26:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192F66B0089; Wed, 17 Dec 2025 17:26:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BC486B008A; Wed, 17 Dec 2025 17:26:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF9D26B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:26:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1742608F5
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:26:15 +0000 (UTC)
X-FDA: 84230397510.13.578F60A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 36A851C0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:26:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fkLPimxF;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766010374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyXeF3JsSIb6CVrnWIdudlC5jD2S8HQaXBz1QcWudyc=;
	b=c15Gb9M4a+V/Dvtvkj04u3kSR2lrzxKj5b6PJFuhhCKwfSujMrK7a56NdGonRPGtHC6A15
	ra8+qqy5DhKkvPDVRXV6JfubAxS69SSoRYpQn4bwPWk99qZtz4CWM8s8IDA73obd140GQe
	UkawET3rh4kpI+ZB5Gb9wwX8wo0QfHA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fkLPimxF;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766010374; a=rsa-sha256;
	cv=none;
	b=V+577TpofFNqCbOeFnDn+T6/8MAc1bRXTyDucL03w1plBh2NFBgUaoTCGfJnDaotC4JAXb
	35j8LHvek33mFWMvkezfTqmPmmB70tORZeSdmnTaeixRBf7OMkOtohkkOE94AH296HWAYI
	XAmnZpfvKP1M+geFOReO+wJu/OeJ4PE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FC536000A;
	Wed, 17 Dec 2025 22:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC4AC4CEF5;
	Wed, 17 Dec 2025 22:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766010373;
	bh=aluNDjkycM9nO1EYCcQspfWRtaIHWsQFfrlraFFei8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkLPimxFNArqio1f/gKJhRA1u2EDDZP1m9gFXxIOFbtZVTIuKahcueBoNOBiBKXhQ
	 mFo0j6gqzaBYqIvKqV92UlrsZfN/aN75k/itnh25fep/X0/+OGgsgSlG4AUP/VNzz8
	 Vo+yeQjJvfwVgKHirR/O1qt+PSdmQ57VSK8l3t8r7Oq9MwDPkHos4PDpk2q2sNyfqF
	 tLxDWqK6pyh9HezIeNilSYJ0mjL98FA9e0N938v5a+Aj36YpRyRw8z0yaeCCiRLg/R
	 xdyBQE5UmG0OzWwzGp60XxzmPmb0npcw8ZkRUhsQalB6dSURsjZ3HVzyWgM9NG3gFL
	 oVO0Vvniw4Xdg==
From: SeongJae Park <sj@kernel.org>
To: klourencodev@gmail.com
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	kevin <kevin@desktop-mu90jgd.home>
Subject: Re: [PATCH] mm/damon: fix typos in comments
Date: Wed, 17 Dec 2025 14:26:09 -0800
Message-ID: <20251217222609.3355-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251217181216.47576-1-klourencodev@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: 5n7mf1s3a7eefrqahqhdxp1q1cktjqmx
X-Rspam-User: 
X-Rspamd-Queue-Id: 36A851C0005
X-HE-Tag: 1766010374-12693
X-HE-Meta: U2FsdGVkX19OcU9TgV02fcHXTNo5AhJyuAsaECPwFXYzVNw5q1ah4SgwRZdO6HH/U+IQcK6qF/7xO9Zru8olw+CfKO5ihibs3aeVR7htVzL5ub4XvUhZg9eSns78LeYzukY+99KXKZEbRtjEIzO/cSEnf04u0GRa+8k2S9RKv5I5/lknjOl1xMSSz50FVeL4PwD8thz1e9BaYdmToFHhq+8+j4QNiURRwhHrTmGIWj3GjmfU/1UYYNYDGBBhDL4+sL4Kque747x8RFkv36zaT6CVAEZ7r3XcMQbkh+C7IR5hrbk8yxxFad+JG20sQW4QhR3FirrQupNLiz05OHfsbaAoRyUCNzWLAzOJUy4CJWDzVMsiwMfFfYGp0zz27QcorN+F0sFwlJNx6VZXGt6pXrMJLImlSi8ltWXHu953yYoJ6w1b/rXqw6w02Uauozd29Xm3WAq9R3AfQWXdag3szvG9Ol/TiNN1SMtUIVD6AMbiDWJ7ikIRno9z9zn4PtIoH+kT4H6CWeMHsXAMjGoc5SZwPJBnPcNEuiAEara0CAcmno2ch2g92QHO8yllswRc2F8YE2YQstnig/uJDKKvl1zJFrz2gWgXQBPAT8ag3kzukfsGj7+/puONqcxMf21g5Z5DHo0E+4Yt+0hhKtTQ0inu47huhGtDjiMnBuZ1vGdZ0nEqQ8chjx/8A2ZhN/X8XR8k/+uYbzcDhMMHYS02b74iE+odBU7HEZNqGMvf5Efc04bmGwuTjMWQglA1MaERii0wW1b5DhzXBRna32JpR+Zw6n1n4/prKVacOL4HUgxAav75I0tkLn0W4JrjfRM/vpHbZsxDczESEcD3NmxSXrqg+crz9G1MMRqN2ApWE4aWSBOIcICMLcjWzmxm78NqfETklS+kKyaq9MxQNxF0rqLuEkeqWKs2S+ZfioxmTAbdbx+noahd+wkFL9+wGAC2LCVwL6z7WI6cwHUSrWV
 EYMcNXSg
 9/7j2SCnXtJDlEc7bH/uWI10xABj+HbUD9XOZRV6645E/eb6KKf/i/iXfXsJF3MHaDVun22sYRZQaNELCWLmfrI8uVOUM8p9M5Avjlxn+NNoKsNm556vq/7eylsqJOy+trTpCxnfMmCxf0ALdFHBtzbqZtvcRCxaT/BmkfhFToNSUZZU+pxM1WWfuFw9B8KX0Tg6FbjmorXH8YXgHCp7Tu+YZS1pBUiSp7aRQDEpI62nWIEvxfceN2hGLeDEZFUxB0VIR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Dec 2025 19:12:16 +0100 klourencodev@gmail.com wrote:

> From: kevin <kevin@desktop-mu90jgd.home>

I think this should match with 'Signed-off-by:' tag below?

> 
> Correct minor spelling mistakes in several files under mm/damon.
> No functional changes.

Thank you for catching this!

> 
> Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>

Other than the inconsistency between the author and the Signed-off-by,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

