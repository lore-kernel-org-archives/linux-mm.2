Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F312E606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H0J1TNFm
Received: by kanga.kvack.org (Postfix)
	id 0963C6B00EF; Sat, 31 Oct 2026 11:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047736B05B1; Sat, 31 Oct 2026 11:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F7F6B05B2; Sat, 31 Oct 2026 11:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8EA66B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 11:39:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50445160972
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:39:08 +0000 (UTC)
X-FDA: 85383329976.12.36D7ED8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B4F1E180007
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 15:39:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H0J1TNFm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793461146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mspr96Dyew9GjRaqoBbyrqZlGPtbBgXGKI0UbOV96jY=;
	b=ujPSvmwYF5JfT6YVHzkw8Gq1oZ5h90YqcRZFj4dF9Tq733/qjhtUSmfLrj3Haha3eh5Tru
	x0sAo0doG2z6ZMLqcgp0ddFOkK/JYTn7Erxt30GTTV9T7vteygrBw94K0N/QhS8uzzJVQJ
	gcNgJwEtOImBsd+uFozLiK9Z/ZKiFlw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H0J1TNFm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793461146;
	b=1ruqtyajlINCejAOlT4X2GHYCQoXaAzv3akfKmVvWYwumRxIy6BviX8L2w6mgRX0AMShUC
	vfKE5P03Xu0I7pb2gB5We2InGRRgOkZP5j5Jo0skdlbuNx3WHCmfM+D+raYq77bcBKBm7w
	07oTObOeqDc9fZThvQaPQim+AoxHba0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 384A3605C6;
	Sat, 31 Oct 2026 15:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8AB1F000C1;
	Sat, 31 Oct 2026 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793461145;
	bh=mspr96Dyew9GjRaqoBbyrqZlGPtbBgXGKI0UbOV96jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0J1TNFmCNYiAaFJK3l778Sec+Hp9f+EaEq+OwIJelwCvKAoviR/oJ/AwqW2uX0eh
	 DOQYTnZkkAZrE1lNg40zKR0xskJGJHuYNsak5zGpvSYKj6TDSe2+mXfhYqofh9oekW
	 5DwDeOWc5UaWPHYoi32coQ9zA+UNG2Z29bomBoA2wMxr1YBLpWZVlzWFQhsJ0wZpaL
	 JOuU3/IPyvkeSPih3Rehvx+awd5FmK4Jtcx6NAsXRsN3fXcZF7I9D8azpNQKrFeHEP
	 jJy+794UZvO/0ALsOGfzrDcHdcpVFTbgRi/M320PH8eVYUgdphYPjpp8hJvEjIlayv
	 1yWbNNv1uIArg==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev,
	Shuah Khan <shuah@kernel.org>,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH] selftests/damon/sysfs_memcg_path_leak: define ksft_skip
Date: Sat, 31 Oct 2026 08:38:58 -0700
Message-ID: <20261031153858.84302-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179342136087.2.16978105493403840270@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B4F1E180007
X-Stat-Signature: dkkfankr7p41esjerqx5rp3tm8yqbkbo
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793461146-411348
X-HE-Meta: U2FsdGVkX18o90JENmnnieClXJZcO/Djoh+IuVhzGOQw7h44QbGCazuhUuyyx6ZFn4EhQbsYDhcJUXCeYjkdRjyKdJjgXxwJp936/SzPlO28qEzcVVcJE2EX2ggZi4fKYnEmS7Sqm2KYDNrNYIo4xQjgT92TYhc6TRUtcC6AX3X2NzXy/grkJFeRiWwZ+rtpVRtCb8cuNbAZARRb9fIJR+ItmVQnYKl6Bl2f+B50HE9coNDkbDC/b14cnkLQRW1SBWWfu042TLsbdaXOziqvDaSgO5gXg7YwiPGJvAj/1lgBfacAAhulqdLtWIxlJHBEi4VQ3I8jH78Dg1XHYNk4o1unW7R8pL+M7CKE35pQhZ5VMAEuHNSldSPqeadohwACOlzFxYq5xup+s9j7f+KPupciW9mT0U87jMpo9kV3BI8+yPKJiDndaOsaILg7rrKfHGwoHU6wEdt4jhY2RDPH1HvYv6bcRyuBYDsjPKjnNycWojV5qUNnFv/dtoUKstwYZPwXMlBN5e6aFw5OzfJfdMk0qEX4OYl4p8mfT95kWkU1WVWVlWexetvdgP9DvJdyTaUnwvJhPzg0ApEPtHCL/n3JH0bylJtFpGs/15LaWIbikDNOarH6AzrOXcL6X3IyDxInOvpXH7natcGl/5jZaUK/VtTH+W19MnuR44oNV4Hcl2nbuFk0lFrAh2SU2yH9t2EMXYxaBR5sLaA6FeWkmFgiEu2vPDRCmsODlXD5Srrchhe6xquXQvGUwMTRtgVDolgyea9FN2ww25qY06QZxHEW5QYVdZR+T/D99DrA7/pZcCabaSVUDnpsOhHDscfReWcbFulM6MrpNdUMwjG8UkYCAFxLZvq+WwS/eIJ1ATgm1PWg73cjGKSpUjjs1l/XBJotyvw55OYfjXOTjRRIybPCexFDKbaAWYZDVO3JhDiQORFsj/Bgcc78NnTeyvraweq56aofzw0FNdbdJpf
 oiZ6B58G
 KIfVJn/9FfyqJErke1G1VjvQkf59A+cF2zcRDGIqHT+hhJP/g3VLN7iPSv6OKe6j303B3O7u5GTnqWAZqtCvvo9V6ZzVWCtCMbiYsCRfRZKUjBbWpgXD7rcSddyEZUUn8LCc0XMtI8mI2aw/SB59Sufaf+gdUEjP6MhSk2EBULBqTdUfgKeeOpRU3RAyZgTHTFLfpMrLTIXx2m3McCU95w4zHEVoPYSPEsFOpmKAib+80tBGjpBfb9Aq3RtVzem7PNY50LbQsBq9vBaR2FogPuwFKaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 31 Oct 2026 15:36:00 +1100 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ,
> 
> On Thu, 29 Oct 2026 21:46:42 -0700 SJ Park wrote:
> 
> > Define the value at the beginning of the test.
> 
> Makes sense to me.

Thank you for reviewing, Aveline.  No pressure, but have you forgot giving your
Reviewed-by: tag?


Thanks,
SJ

[...]

