Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECF1C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 726EE8E0178; Tue, 12 Aug 2025 13:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7008E0168; Tue, 12 Aug 2025 13:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C6448E0178; Tue, 12 Aug 2025 13:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4228E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:13:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F363B14012C
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:13:26 +0000 (UTC)
X-FDA: 83768751612.09.71A672F
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5EB732000E
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:13:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OJEUzrGT;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755018805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wubMNg3micGNenyNHCC+nBq8c3rCPqpcv3YyJnmLg7U=;
	b=WG9iyS+0dTHTA1aHtqHLZISCWgoWMMKdklT+7UrB6NRtgQJoanpLnXBC5pQH/GAwLQVhV9
	SoKOF1NVBtC1tiNu1dY+F6jRCJF2mm1Ljzlc2rKSULF4wasVJbgXIp4lkRG4eMgJ/w/etu
	SreNpcKY/46ZvSbSH7iPXTzy2yJD6Uc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OJEUzrGT;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755018805; a=rsa-sha256;
	cv=none;
	b=Lwt8oGkrDfRV0TduqOJY4kFve3bPs7Xeddw5YLLRRLW9swGBe3Zn/ShyX2+kHerfjyelEw
	KtoEZIs7A+uTsP4LrmDKnUhGXEgaM9E0A7F1mOkONk7fUZfZ7QRnKJ/dxhfD0JuJlEpxr2
	Y3k8fMuHmQK6pYaL5ieGxl5+AgboJ2w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 3F3635C6A9D;
	Tue, 12 Aug 2025 17:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7793C4CEF0;
	Tue, 12 Aug 2025 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755018803;
	bh=DDL2bVmixo4qjz0buf9nt8YEqAI27C4kZ9s1B7RDXaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OJEUzrGT8Q8Oh2evCaX+1T6cWfuLAh9FOBdhc8w07mZxOzdNxo1oTkevmWUDr9NVE
	 ee+TsJCI1KznM+XK6CcNEQRSjuBlr3H/WwyN+htOlPeU1zJxfGqsayu7cbQvsM1w5s
	 zAmVArfjMl7wl8fZEK6x46X54FImdWpETPXFzhPEzMIdrNEdxUuU9Wq6nrjV5bI0KU
	 P+ISMBm7Q2iAbJnHDXSB47/SC2hnDQikyXvTxwAjTeJFC3I0nERpgt+5YBatl/aOHL
	 FZOtaArV6oiOdeMkvkyzeIkdXnX7Iu/Y7b+Z/IUrYPGCNp2J8OaIJvVAuczk6uRkgP
	 SV4//JL7FbqCw==
From: SeongJae Park <sj@kernel.org>
To: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Enze Li <lienze@kylinos.cn>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/damon: fix damon selftests by installing _common.sh
Date: Tue, 12 Aug 2025 10:13:21 -0700
Message-Id: <20250812171321.56978-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250812-alex-fixes_manual-v1-1-c4e99b1f80e4@rivosinc.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5EB732000E
X-Stat-Signature: krmnxtqiz6ggsct4zc3w4ug9jbcbq8p3
X-Rspam-User: 
X-HE-Tag: 1755018805-995038
X-HE-Meta: U2FsdGVkX1/Vs7HDGQSotTgwwxF0FYKhumjNpem0EYz0Nu1zDJ/oQSDqLtDCG2hmkLz9oZwju98/kgZbFHBWS8QBoTpGKZS3eTABL5UjiXEqa3eymbuIS1ooB/9TJmcqLWjKr75yEBN5VDnz4s3y/zPfJX5/Klrf8bNgH+mBkThnhwUv4wVoxQrCrtc3dvMzj9c7TkdLgc8Py9fUAo/bKVmTk4N0Z9cDznF8/2DXj8nQ94YNGf9PeonwD+acCmSfwlDbgb0DfFj7AfEkBgB6NqmQiNXNxvS2rfZC8P6ihdaygah/P0r3EymoylPDQAFQi+bSN+gvJAcPTXbyMLDDSBOkMDFZW24HTx4umu8l0fOaoN14/P8+U+OiSlBnVfjzflM8JyBjJkrz74zjsxeF92Bv91vsdPkGvUcC8qo2a+q8I/zSTzPxsz6zDRwWb+1N2x6mZHn6Qc7oapnxWEtN3jPJzEvmFR3CY8DoudysTZuuG0+fEeoM7biBbDw6/BFV2wlZVD7OSXm/WBc22DdbOizHOFFPHBLdjY60W9R+6gDeAY8bgyne55Raqg+1ONjn/Px/Jna++CY6npoUBRMPrcDByWlHJYPpQnwMOej4Adn5sgFHm2YNjAcPeeCC6oVvzeiQWndrxesPr7qkiheie0ETdty1d4Z6O5u7Nx9AUxWhsdpcAqHRH/st5PMW4fiR7lIZk6P6ALxUqnzpX3OpelXW1N3WPri9L3K/61QBCknfkql9i+gO6akQPHKIdd46wGJbKHYovZDUSE9FAvF4FuMaGUYn0iLBsue5RvZKtdYXaWbQAMH6Afb3yXRwnfhhrdCcr78Kqbngbe56pdYTYURLpuOpgQOYd9cLE8KO+4oCqFo0TSS6/gqCuIfSbNXV4XBn8i8eH6TJKl+N7Sezyeoceb6zKAbive/KhAyIejKv/+qtnNwQmV5ahHPcaTieJkmvx0s1DczVQ6TqETT
 XGmVz1DG
 R76lt5LzkhPgC0UrhC70esW3BbfNi07QB8kkq8WNaMT9lHuyZxw9mRktefzRMJ2+lN8wOFjvJIdfJpuKeVtN/iLeq7d8dvi9WfEFOqAkWNs3GuOMqjdAmlccdcPRrv9MOwfuhEwwjIdQ8CDY0a5yH8C/s0YERuXC36FxGT9hTRmFxo/LlJCTNQiBuWqqB2pHyFPzvA+OF/UcrcS3FXrU20RsFG3si9knXUD620S+bMI3tBoUgCyaKbTB3zzI9ws1FBBfCJ6FRX9WOWAAJ75/REURgKLTm5AdDCleXkidf6bdbzoX0XRo8vn3xDLciupQGHQr3x/vLS7WBFh85HCUB9Bv+nlNVxxFfKJN3Wiw6xIOw1H0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 08:12:11 +0000 Alexandre Ghiti <alexghiti@rivosinc.com> wrote:

> _common.sh was recently introduced but is not installed and then
> triggers an error when trying to run the damon selftests:
> 
> selftests: damon: sysfs.sh
> ./sysfs.sh: line 4: _common.sh: No such file or directory
> 
> Install this file to avoid this error.
> 
> Fixes: 511914506d19 ("selftests/damon: introduce _common.sh to host shared function")

Thank you for catching and fixing this!

> Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

