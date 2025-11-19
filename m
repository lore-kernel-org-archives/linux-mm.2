Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B00D7CF58DF
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 20:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F30776B00A7; Wed, 19 Nov 2025 15:07:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0926B00A8; Wed, 19 Nov 2025 15:07:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA95B6B00A9; Wed, 19 Nov 2025 15:07:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C90436B00A7
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:07:19 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D61E013B53B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:07:16 +0000 (UTC)
X-FDA: 84128440872.09.E416390
Received: from mout.web.de (mout.web.de [212.227.15.3])
	by imf28.hostedemail.com (Postfix) with ESMTP id A9301C0004
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:07:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=mc62ujtX;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf28.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.3 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763582834; a=rsa-sha256;
	cv=none;
	b=cDa7vWtzXi7p3NX6QvL2IlrBgGjnd3aZ0CCpOAViOvPyTlGb7/XWTUi7qj59gOSLtkseKd
	yYQbz0l79I4ol7tDAL5coPzRsoW8RdOzDwU/uIy6Z+l010e/8jllPxbeV6Tai8IGLBvtpX
	5xSaSGXLGbO1oFvJYV5dMFES5NLBS6s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=mc62ujtX;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf28.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.3 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763582834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkG3xSz9u26p5lS7gb+hO/SOU6KafxqoIrcKqLlC56g=;
	b=o8iOuPbqaHffJ4TVcBszI5Pj/YKDCFrrg+LEGO4D5VpDjBJ32GxAcuJ3cBUqYatH1WD56g
	LksNKXjmZSSZ8L5NFYBcjtVDc8eR6N3hTF1djIh+i4Kz+4VsDhimG4jsMuc1dQT34dqIq7
	0Eb3YCHuGJ+KNQl4iGu6YrGOBf2+t60=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1763582811; x=1764187611; i=markus.elfring@web.de;
	bh=kkG3xSz9u26p5lS7gb+hO/SOU6KafxqoIrcKqLlC56g=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=mc62ujtXZrSB0+1SF5ZCXbs6jcEKJVbSnUQrVmUPKNOE+ItoRZ7j+6fnmnFXR8S7
	 JLHPEpcqYc5NNqNRWJPP0XYI3KnRVxXDypJQhz6JHzKRmkSjssyE1iBRYXblQr5Tk
	 OCdSZYY8HmHIR5WkT2QqEo8jyqHqLK2f3iwXQl4i8hFOgAyfPneZ/nvt9r7b1dOEe
	 QUSZzkVG6XosPm3dafAiSD7cpAA3gcdaR2IrEwA7yUL0zFaq8wxuq/9NXyxrkqbAm
	 XX6GNIx2JY00eNSfJ++0cPr9mShDsfDF4hV0bzTg4pmqZ5AnmywAvfl5ACW8rNY2r
	 vw4TmCAyiOZRyjrr8A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.228]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MIc3F-1vPNE60xHh-002PTF; Wed, 19
 Nov 2025 21:06:51 +0100
Message-ID: <d41ce2d1-e353-4e5b-a17f-52d888a560b4@web.de>
Date: Wed, 19 Nov 2025 21:06:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
 linux-mm@kvack.org, Alexander Graf <graf@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Matlack <dmatlack@google.com>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20251118182218.63044-1-pratyush@kernel.org>
Subject: Re: [PATCH] kho: free chunks using free_page() instead of kfree()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251118182218.63044-1-pratyush@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HKEaNdERLakoETr5n3PgWqadzTYxEjx5X442XJNGLiOv42anTHD
 CepNQwMlL6QmRcCpS1FaBMpgnf400pIHWQjaSApYGld/ObvLheDKLg0nEE7G+UAfE56Ua0y
 KIoaPfexPymV5iUkrqiuiICP9omBS9PKXIxqa61XQjaw50Yc6N8F+q96FoBKjZO7N+ckR/c
 x4FIwwqYqkGuX/CKHUarg==
UI-OutboundReport: notjunk:1;M01:P0:B1s/PZky8Es=;Fiqp9Pai18huiHDgbvadx+99jQG
 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
X-Rspamd-Queue-Id: A9301C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: 9dzcjhadfbx1am1koxm3x3ts6wpab9u4
X-Rspam-User: 
X-HE-Tag: 1763582834-520126
X-HE-Meta: U2FsdGVkX18vdb9UHqV1/7EOCzrBDTD1WYsoKThT25nnN67ZR/LllHELM2QFQmAHygvwOtbHyBBn9djOEvDIIhNxOpAoKeEZdIi+5ce4c9WtDvc2Lak04cgyuZ2pS8IdEjHJVgfzf9JcQ45GY7gjnN597BfkNbUq00JCZvlKAYGaZGEOM1bysmyAzDP5G3CZNnZeQgeU2u7IKWTNv6hwhcl1hifr/VtX/VSc8C7AA0Px+fJR0ytTWVawbXpHyu5B3BvwudJ+xYJeeIlmeKfcu65/aRpl4Ku2dfa2pTeZrYHylLIEQZcRwUj76wS+Cf2wIf0j6+N53NChOMpRWC3Jd0wASYkpoPvwbiZu4mS3FyvL1q+s4ELufNP9UvyIL4Z1v8zQqUxiSK13yfhrq1VPf8nKvRtJJw9aaxbQ20IKJRsiUUdvNxlNbsmmj2XPgxttLz7466Crm1bGJYOehRkPUgpAS9JNKyomJSniugwyBvfGK5gtV1eXzfIZ13eZCuHyy4BCB8HOzwCRpYtlbY3dV75uV4zgQaFeKKPeq1ttaig2OnmyKpvo5eq4s1js+F9dvGBkaraVLc05r2n/Vqq01XenCgFjl+RtYMdbWK0Xqp2mvlzsSevlN67n+TR76UoSmDVnrdAdSoAjXDGwK7DIK9/BYuTNEZZhqo2PC0chXjuuHuB7S4cGKrt0wEeRGmsyt6RwD9/R9M8kYpqpaI8oXIWSo6PacOS+HSx0DbYxt+llH6KpyaxNBnz35xlw+AqsX/RVBtx6KZ7xj/Dv0SDryxEnAFrR9feZlnpGkRf3102QjjG5B13TnMO+c1TdLvPxcPH/hvRJt1fxKdp1VlSiUGU6aSqmbSWBT0D+trWK6NR7hGVaDCl1/HYddpjmkSA7sl1Da3vm4bEryqyS/C+aUZ4FwsLf94GpRsavPe4H638uyIm5Af90peyf9LnW+9aEj7ZDUf1UdLzFOOBiyx+
 HV4TIn3t
 Ic2LrGVhtX1EVdHclVDzPbHx60FI0A6BA0i0TMNRwVmzWRoIiRYyJHOFUX69+xsxUR6qJvFsfIlEQv7HYQcDGFI+8aVgZmcF0JewxGwIvPt+E7GhLqX05WBtTe4Q8TqjILAlxtJCfH80Q0r/ELD8yIdMxtYpuTwO3OQCrMvUNh+MKAs4dhPZzOU8zcXGqRIA3s7wQvyhptPdCRi9GuKMTzIZ1f+07payKJcj7fcGNZnGSP31wIN8MNd6/xbNCJyn/HtHNjaa2u+J/JLuqwH+tGBRsLyPXqC3XEqZHb9KYIeAe2Kgdt1TXCeg1kerUrkuuzgi6LOzLqwAJ5OKDaU7di8KzDmB5KPNx6b+TGoZfK8O6V4fdvVZodre/CfK3Fav78a2nWdIubSFhQFMjq9rLvQYKa+14woMjrpVQG5X1VggiCZ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=E2=80=A6
> When the commit switched to using the buddy allocator directly, it
> missed updating kho_mem_ser_free() to use free_page() instead of
> kfree().

Would another imperative wording become helpful for an improved change des=
cription?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.18-rc6#n94

Regards,
Markus

