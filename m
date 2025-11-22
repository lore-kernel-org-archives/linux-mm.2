Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADCD3CFC516
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 00:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8126B0010; Fri, 21 Nov 2025 19:50:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88D76B0026; Fri, 21 Nov 2025 19:50:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9ED16B0028; Fri, 21 Nov 2025 19:50:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C89C56B0010
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:50:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 739F7BB2CC
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 00:50:21 +0000 (UTC)
X-FDA: 84136411842.07.D83F71B
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf28.hostedemail.com (Postfix) with ESMTP id D65EFC000A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 00:50:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763772619; a=rsa-sha256;
	cv=none;
	b=PI27/5wgWsVqKZ/mrfTKWVpSPaM8haA71eHWVQfBBfu/rCvo4VKk/2DSTuwib6deqsALWN
	E/on3XMP9Hlvdbu3TBTv9S4VZFMoatmO/Jh1sFIVlr2xjrkl1k538cSBztCw3kG2AHJyrv
	gBrWjLmH83y91wlmM/vQDPrG14P4oqo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763772619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5e1PSYrFHOYQuG3hxMVOVuOVwvEq14TGUuiH8ML57Eg=;
	b=AKRV9Ye9rXkzpioWIIeub1fUBKq8pbjIr4ppNejbPsW51vb515eNEwOdFk1eSCp7MxHFrq
	ZJ0mmBmqMMVeV3EhYkyYGTWjJLau4QbX50RJGT5y7wSdKozJm0LDDW/fgHBJbwj5m3YP1S
	msbOvWL5kDafUevSl/HzgzTXQ+Vyt1E=
X-AuditID: a67dfc5b-c45ff70000001609-cf-692108c499c7
Date: Sat, 22 Nov 2025 09:50:07 +0900
From: Byungchul Park <byungchul@sk.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel_team@skhynix.com, harry.yoo@oracle.com,
	hawk@kernel.org, andrew+netdev@lunn.ch, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	ziy@nvidia.com, willy@infradead.org, toke@redhat.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, axboe@kernel.dk,
	ncardwell@google.com, kuniyu@google.com, dsahern@kernel.org,
	almasrymina@google.com, sdf@fomichev.me, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com, shivajikant@google.com,
	io-uring@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] netmem, io_uring/zcrx: access pp fields
 through @desc in net_iov
Message-ID: <20251122005007.GA57205@system.software.com>
References: <20251121040047.71921-1-byungchul@sk.com>
 <72e3ecdf-343e-4d1b-9886-67d48372a06e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72e3ecdf-343e-4d1b-9886-67d48372a06e@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe885OzsuR6el+WagubBQySwUXsTUD0nHL6KI0QXSozvmaJsy
	L2kROUwtyWu3uUmtC94zWDKd2ChnllYmirpMbYkmXitN0QrLaZLffvyeP//n+fBQuGiOcKak
	ihROqWBlYlJACGbsHxxopdykPsZRd1SzlI4qrI08tFw7jqGyagNANUOFJCp7f4VAC09+4qiu
	KRtDxqZxgCbVj0k01jbCR5/KvxCoObcBRyOFr0k0m91JoC5DAQ91mqtI1JBp5aOepjISDdf+
	4aF2TRWBrg4+I1CbbidafDMNUG9pE4buD0ajbvMIgbSqAoB+La3mtS+H+cEuTH3VB4zpUxcT
	jMXUgTFGzRCf0elTmaeVnkzPu1RGX32NZPRzJXzG2DiPMflZsyTzfWyAYL6aeknmra6Vz8zr
	XcK3nRIESDiZNI1THgyMEST0//BIGsPSV/Ky8ExwE8sDdhSkfWF76QK5waYiFW5jgnaHA9Zx
	no1Jej+0WJbXvAPtBaf6W/h5QEDhdA4PWlV3QB6gqB20BFbm+9oyQhrBou76NS2iE2DHjP26
	3r66apSwMU57QsvKBGaL4PRuWLFC2bQdfQROfMsBNnak98Lnhlf/riym4OiY/zrvgi8qLUQR
	oDWbWjWbWjX/W3UArwYiqSJNzkplvt4JGQppundcolwPVj+h/NLv041griuyBdAUENsLw2P3
	SEU8Ni05Q94CIIWLHYSTfqtKKGEzLnDKxGhlqoxLbgG7KULsJDy8eF4ios+yKdw5jkvilBtT
	jLJzzgQi1yBevM/JuNQtaFYR4HXM7FKkjXPdF+EX1N7XXRcYHo9rrUOhrktOJ4pXFDDqeOj1
	9JDYqGjHGxcj9Kp4txL2bue90IdmtbzP4O9ZDWNUC7msTl617FWrClabkHdiWLMiLNLjY3D9
	memQo5+nKi5vfTSf0mnEb0fdmguTjYqJ5AT2kCeuTGb/Aq6Cpg0FAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRyHe885OzsOFyeddVAonZhNTSsUXlAjieqloMQvQma69NCGOmWb
	5gJDMS0XXhHSuWIROHVascTLKBPnJbU0XeYSb1i2nKWmFVqiOSPy28Pzf36f/hTuMka4U1KZ
	kpXLxMlCkkfwzofmHu6kvKRHBi0CaFjNhPrpFg5cq7dhUFvXBKBhopiE2sGbBPzx+BcOH5ny
	MNhqsgFor2gg4Wz3DBdOVX8i4LNbzTicKX5JwoW8AQKa7/Vy4JumIg4cMNeSsDl7mgstJi0J
	J+s3ObBXU0vA2+PPCdit2wt/9n8BcKTShMEH43Fw2DxDwKqcIgB/r271VV2T3BMHUGPtewy9
	qyglkLWtD0Otmgku0hnT0dMaP2R5nY6MdQUkMi6XcVFrywqGCnMXSPRtdoxAi20jJHr4eQlD
	r3SdXLRi3B9JX+SFJbLJ0gxWHnQ8nicZ/S5Km8UyN9S5eDYox9TAiWLoYKatJAd3MEH7MGPT
	No6DSdqXsVrXtr2A9mfmRzu4asCjcDqfw0zn3AVqQFGudCJTUxjsaPg0ZEqGG7e1Cy1h+r46
	/9V7mN7Kj4SDcdqPsW7MYY4Epz0Y/Qbl0E50ODO3lA8c7EZ7M+1NPVgJ4Gt2rDU71pr/ax3A
	64BAKstIEUuTQwIVSRKVTJoZmJCaYgRbH6/OWi9tAd8tZzoATQGhMz/yiqfUhSPOUKhSOgBD
	4UIB3x6ypfiJYtV1Vp4aJ09PZhUdwIMihPv4Z6PZeBf6qljJJrFsGiv/d8UoJ/dskKIMCRis
	r2oUxQx7iwoaNpVP1odGC8qRImqXHdqn9KIL0SHnqIM+BklCRICrOab3UumNMi+3WHH6afOQ
	b2yBbbdB9GJNK2sKqqgNE7TfyQoKDY+YPGbUfzikOLlyqiaibHHeZ6RYNdBT5C+Lut//Vlfs
	eXl9SuoZuHxNvxDYJSQUEvFRP1yuEP8BF23cqO0CAAA=
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D65EFC000A
X-Stat-Signature: zt9fx95is8ne5z3ectk5z3n3qa3r91u8
X-HE-Tag: 1763772616-73726
X-HE-Meta: U2FsdGVkX1/Ebb59WqKZS0j5kKmS79H6O6fi7eb+qaSMWyngVR3JeKPrBcOhIKM30UydlZ48sPADuKJlCoxNSEdwCnR6wY76Zo/QzlYH+cLLyExP7Z4+zXvt9rsA/C7kpXrOufepq2uhe5MHYX02FGdT9g6oI0zHZNzvvGqmYetiLN2SeoHOeXKwlu58DEFJakz+vAoxyfskuU0yramtZiSDF+xcpQ9hTtFl9Uebynwz2rf9MsM0bKEVZEFZk3lmiY1/kanuCsPd1+saVf1qkjJ5JkTSee2D3maCePoaZaGbuCDrhzJfXSJUuYSJLwtYkW4lwoAuNQ1ToviweYC7alw+8Iu7A6wkS5wE/fg1i3o69qcYhOWSVnqPOvawlLxJHRq24oGSnQU/tRV+jIKz1fs9bt8RlBkrtZUkZAF0+S3NxK0wt86U+QgstdDp7ijP6uP5VlEjJNqHoOHvS3yl2lf+QK6AqGS3g1+b8j8MyLerK6pgInWcfehFSJjhSOuqJTCrC6uNyCphHKPZ4MU4pwiToAYP84uoNgtk6UGa35zmUt1Sc9Qk1qhnOKqHM7okbpQqIrhAyIScHXxZ2qRTS8ZY3CsxJtf8lNHYkud1kjwGfkW7Pn4pVMzQ3E5zPQypZ2xCPNWxKtXFr/7vpG7H+HhPEhYPKT9XimzQ+n0ADyC1ag9LHBtYx6WJJxmWaOzqdMz037HjXTiUscfhqWLfN816J7gVtpjtgaCDvpT1pAV2vsVXIHnkKQ/tcyqy9wFWy1O9Ol+06kxapdgHBtjgWvIbJ4c08QGvmN8o/llTa8duZsPVL7UluY6luG5N/4WVWlwMd3KlkzFmFoIhNQwwpPBs0dC5HBHkrEHWsD1VLpWqUEe2rVoUWp9XOm4ED2uEksG5hFpojuq96w5i2mx09e93CQ3yWAnEMMXRP/ZxvhAlmot2mC4cpFTT5cb5tX4aDKfmoU+ig2e2OSjdQFt
 zs0lqwdc
 BDkAA+N3gg8ivDYN1nNxYZwgi5VeNoeMFsUIj/aMvNJljuNMjfU3DUGqkKJ5SU3kwzPYQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 01:02:44PM +0000, Pavel Begunkov wrote:
> On 11/21/25 04:00, Byungchul Park wrote:
> > Convert all the legacy code directly accessing the pp fields in net_iov
> > to access them through @desc in net_iov.
> 
> Byungchul, that was already converted in the appropriate tree.

Nice!

	Byungchul
> 
> --
> Pavel Begunkov
> 

