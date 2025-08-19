Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8C23CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 15:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66F8C8E0007; Tue, 19 Aug 2025 11:54:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9138E0005; Tue, 19 Aug 2025 11:54:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50F038E0007; Tue, 19 Aug 2025 11:54:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3C07F8E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:54:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E95061A00C5
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:54:03 +0000 (UTC)
X-FDA: 83793953166.11.74BA3E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4EB6C180009
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:54:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GnzJjy6Q;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755618842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svXj0SlEmaSH5m2mL/kn37o4jiiv4bl0XEF7tAKg5ns=;
	b=nHtktHelwdI/843IZn7hQdoPXWsiOn4DfHhCIDMMsG0KQOtc3oOxTkOUSHsCOedL+Cygnx
	bjtw0SFqSa0hc7TtTefDUJ6KWNMFZ8h2qrQ6AxEWTYvESREJnq+GqDVLcGTgwlQ3TAALnE
	8tv+biXaes1zVEY37KZvRzHF7j7DEGk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GnzJjy6Q;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755618842; a=rsa-sha256;
	cv=none;
	b=lb3GUgnXdP9UEYNIYBHzRJR6u3yWzW8lWzEAdLLe+HKk5TSPlIcnVUZCz99y08OiqU4Uh5
	0Y6avcmmEOPNbfA+EF7ftvEPa0dGi1DKl1e3NkvdFLBmO7yeXGYZmL1nRHATNisu4LfX1P
	hkDSxn1ChpwlspIl6+9SqXvwSNSefeI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48D4E60209;
	Tue, 19 Aug 2025 15:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D213AC4CEF1;
	Tue, 19 Aug 2025 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755618841;
	bh=OJWuAh0cap69AqsWPSY5ghpUh2pe62oNjD5LFhuobQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GnzJjy6QJWEZMcqby76tjDwiD6TbLu/1cmOXBgrzC0q684ceWOturm4HEC9W4q9O+
	 eL8cIXDtDmn55LNEpztTHGJyofjA22PgPnIMOhgvwtvDhGUSXNFTkyWN9b2b5Zf29H
	 IQr+05neVBTXHf/2wG2Ga2p+GjFf17ct5LpEjb0rta9ZWr6vbkn/lCRgaMyoNjEfub
	 949w5E2c4ifMZW4eAjTl9OoLiM6uOuCFkfKasWYpNl2ekDBb27ncF/xR4HkVjY26rg
	 WE4F+NGbJSc3VIRWtnAvn1LX/q40a9LD7hCUyQyKYL+doxSFseRnKD2ZFLWWaWXZJ2
	 qFgU2PtLocDqQ==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 03/16] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Tue, 19 Aug 2025 08:53:58 -0700
Message-Id: <20250819155358.43711-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <6b9baf0c-fdc2-4f16-84f7-c4ada507f8f1@huawei.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4EB6C180009
X-Rspam-User: 
X-Stat-Signature: dhea4ko6h3pox49waoartegu3r46m3xz
X-Rspamd-Server: rspam09
X-HE-Tag: 1755618842-618786
X-HE-Meta: U2FsdGVkX1+Y/zdxSMFxKzwpOXbcmE4SxMW5bvi1bOU48Qse0GilqrRnOZaFtig2roncTMsiFFOAUcDbPRA6nHVZRxKKpu34L58STjOxZAjWuxGlMUKy0prhkh3aDW1JBLYDwAO5v+K7ptVtdw299cv7sIpaWofB4LQqGKHNyF3TWkyMRuq03IUTyzVpanABPQ+rqs8/gBpDuZ2tu7NUn7+X0KWX5StEZvKJAiChAb3x5kwthLXg/0I+bECclnHrgzmkftaQa3Mu35t8oYrcN9+S6NLYhuHNt6wmDy8tSHFcIj+mGfYi1WIi51YGcb2EmJ+hMv3vyUebDXiz5ssU/oGo5SCVOVOJZ+FPq8pkS1RZplvW5OwSlFYhhEQdjSIrlOmMdj/vi8IiVLfkfCcyj13lCl9+y2Ofg7XIByTIoP2AztVspjLuAs35hINoZ52XkoAXITTw3GDuEk7fYXYhB6Av12e7xz/8ixedg3BVq7G9ZmtB7nlSEAcPmDqRhFXmUmbMbDsBK6/ktEMiY01o7tnCHugENg4ZW8BshyQ7YluhaiJx6DFh+rekl8Orj8tOI3N9xFlpN8RvPJ8POYRpFfkrmZ0FRaQKY7WThRAJV7z+r71FVKp4N0xNTC26NWWefoOHw0v4Ivs78SSiuDmv6yoIqcptkNkYfqBaZbtHT38Dnmz3Ru16JpU6Kb0q8jG4Z1fEOZLq3k3sliS9INNDAtPJ/YzDJ7cGx4qvXFA2LkV5ZHGFs3oBvLUrJoBGr5r5z8GZ86QzpiTUmpAGWYCo92/YK37K8S0K3YvN1MAADHT/hxyPdXGSEYUBsPf8xEbMzvQ4jXa/2/UsBXHGvp/QVRhCLrAKawhZs3kKkyfRfRiccr1Zx4+h2eUlNGbHu99Z8V/qfVmbPLacxdgoGWUW94oBhbXKBqTb0vjxh416ytOj6XUBDbJgbSquD5hIF3lNplysavnltwzjj09QJSZ
 PlsiwajR
 BjPAhwAdFxM5+oKoR6t/pMKvx9NH0S2C06SsVD55oh2rMj70GYQ+JpqWn760qGezR7cG0SyRM9Zz08e+QUkd3eSqiyd9siJ/0sER5lNe08jGbWs/0pE/xhlDvxx9j69CyWu8MrKZworVHUWHay3ZppXXc8QfDqDKMTeHr6QUoQEymRsvdTxnpcnrFfxBEGIFIcEn95mPTFCTzInaS4hyvzg6lL2sbfP5FlziK6o6E1ma3uVAH/FN7kbicvJgHzVgKK89i25fj6Na1Tpm2jJY9y6TNhN3xSPe7ezHPGKXpBeT75AJx01LcdZhwTSD/2Y5QrWZy5r2QTagaUYyR3FLhR8iDtKM0xYe7kqKmt3aR8FbWG0U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025 22:18:06 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Hi SJ,
> 
> 在 2025/8/19 14:26, SeongJae Park 写道:
> > Sorry for the above wrong link.  Plese use
> > https://lore.kernel.org/20250813170806.6251-1-sj@kernel.org instead.
> 
> Okay, I've merged the corresponding changes into the original patches. So now we have v2 versions
> for patches 3, 4, 5, and 6. I'll send out the patches later. That understanding is correct, right?

You're right :)


Thanks,
SJ

[...]

