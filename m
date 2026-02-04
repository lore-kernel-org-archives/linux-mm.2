Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC0F4E7FDCF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 06:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B52E6B0089; Wed,  4 Feb 2026 01:07:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 563456B008A; Wed,  4 Feb 2026 01:07:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C6E6B008C; Wed,  4 Feb 2026 01:07:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 388936B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:07:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BFCB013B801
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:07:02 +0000 (UTC)
X-FDA: 84405741084.24.216280A
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id E95DF120009
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:07:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mg52tzCN;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770185221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FguD/Jmk4BwTZfFZIdyNc64l/P9T5XMy2I61XbcXxvM=;
	b=b4iCxhS569xO5xUzZHCdZFQH/UYeAynPi97Zkt9W/xgoDl/EZ4VX0anE6AJ82JDL4in1Z3
	zPACSZeJPUJChZda11liAm0ZLwKDI7+TUlAFFSL6SFzkKkuDa+7dnO0v8D3+dhJDeMGXSk
	1z2Pl98FuvtVqZi3BhlenXKGgVeiqes=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Mg52tzCN;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770185221; a=rsa-sha256;
	cv=none;
	b=Zd7b/JNm/D5ogo/dinopI2C7D8qiWxaxTkBnMYno+iZ89mCbM3vCKJMaTLtEdLmuO8awQp
	6AYglu927Y2y44AnBdbq/YjsXIel1GcKYsc6ECrH24FWNDZiit8f7IOwlbYXiEfHqppeC8
	WrwAjWGhN4w2GhlLpW0qV4Pb+5c007w=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770185218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FguD/Jmk4BwTZfFZIdyNc64l/P9T5XMy2I61XbcXxvM=;
	b=Mg52tzCNcLklqvPmjV6pKIb2fnq8a6CHEYApvj+iYB8x51FSsUIicgNB9B6jpn1332VK/F
	9/w3SJLh4UStR8W/nAQco4kYgApMRsvDvvaBd0Z0EJ60iGuQ44Wh7ieBcSQS+IzdGVGm6T
	1yi2Dv56D7PPauSEJkAeSCdUP0lZzqU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v1] hugetlb: simplify remove_inode_hugepages() return type
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260202233617.2350734-1-jiaqiyan@google.com>
Date: Wed, 4 Feb 2026 14:06:14 +0800
Cc: jane.chu@oracle.com,
 osalvador@suse.de,
 david@kernel.org,
 william.roche@oracle.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B6A091A5-B25E-41CB-8882-493E006A0BE7@linux.dev>
References: <20260202233617.2350734-1-jiaqiyan@google.com>
To: Jiaqi Yan <jiaqiyan@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E95DF120009
X-Stat-Signature: q7q95dkxiew819pjgcoqbrdhbxx154py
X-Rspam-User: 
X-HE-Tag: 1770185220-100482
X-HE-Meta: U2FsdGVkX18l6aMFCN+9+5Py4VdPitP9RRyEYc8lJjxLAuwfsiG8fesAht/EjgHHeReWuIJD4rUAgY9yftKzISV+Xb1IB0ImJWIKieoSUuF89wRt7e7XMcg5ZAnSx+FEWrf/qLW+t9N09fQaPQEp+DwITGeQpWQ19ZOo4r6BVR3YA6SO86MWz5C1lpHMm9XuvpcQ2NGycCQhneoP4uw1EZEDhU8Q10IRdmqfXBD88VaQ/f1ygsY99krnPjzDD8zMKkMB/DxlQBdflfQDdpPfTgKROvwfEHPKznCJUL/RXhy0gfjpwnHo11XPAwhTqtGlNuGtlE/bkSL3OFDwuG9D16qzG32KQg07AX5QZSJUrlhFG/ZqIq/5j3dtYE8qDhYtmEzovsubVqsFwVhttpAfenrf3OmQv1ZAmsEkWspzKy4ONK2exc6ru/8e0CuBLF4q4Ryt7dQGWjEW7rnXjGLGj5gV1AwzG/N9Tj+YzNryLUc2zDtxok+6nWpwlFG5s3w1EhbMMHOXPsE4WVyEI12RS6X2IfLZBJBKqilkzZrSOfwiEq71VNlAtZWsY9znImtZwh0nKh+Qq6dLsXaPV/aKlxUobHRt1BHNJoeBCcVxX47ycgH6Nx20oAZqw1Hof209DxxFbO1Gr3/haKT0POKlMzNC+dMd9EzCGEa3fB3cYDmm5nptTaYNPntAYRIeTJyhPXmuZszG9Fn5EEzlOB0NogH3wZD3tb0rblqASahBo3bPI90bRR9nLMnsqmEXnaFUjjP9mdw3NgabkhJsLY4PKOuo46/1xlHoQoeewMYrdw/prHkaGJQEg/suwvDa4DPUzcokIXVhSr2bEaQlkvEQ/YrcfGiIcQACIwWm20byWjOzM5I6Ni/23y86BDjRxp2kL1v7PtXLjAgmSpYfb0RC3HBTxCkR8IAlq4Ov3fjg7k1zk7ABZtAUjXf9G4Y4C1s5S7NORKwuRg//bEgR7DM
 aI4YZ8e3
 ebnOzd2M9fMSizdBKq/3N00pDB+sMpXPu1i2YXJHZASLHS25JlfXE9ou8OUonrHs/ab8iZdzxuHfAYJs8uulgK8p7/pk2hSnUROn0rFccN9N0bsKoSyhVJZ93/LA/0yg4XhR+D7vj4ThmV/a9jPWB5z+GR8e/nag3ZcJXiqpRqbmMVUQ5wZjdOvLotkFRGYjmCJ5S67Z9RSKwSJOATJqJWxlnhAePS3cxLaavQZq7zRc6vOdq457L03ACsNQNyPJYWrpnWeF4woPonLn/Q2Ry2LMGoOVTCQYxn60D/d7o0oI2zWZ3kIPvpJvmfLw72UHAcNu7AXMvMxPGvmktK68YZNg8QF7g+NQG2ErL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Feb 3, 2026, at 07:36, Jiaqi Yan <jiaqiyan@google.com> wrote:
>=20
> When remove_inode_hugepages is introduced in
> commit c86272287bc6 ("hugetlb: create remove_inode_single_folio to =
remove single file folio")
> it used to return a boolean to indicate if it bailed out due to race =
with
> page faults. However, since the race is already solved by [1],
> remove_inode_hugepages() doesn't have any path to return false =
anymore.
>=20
> Simplify remove_inode_hugepages() return type to void, remove the
> unnecessary ret variable, and adjust the call site in
> remove_inode_hugepages(). No functional change in this commit.
>=20
> [1] =
https://lore.kernel.org/all/20220914221810.95771-10-mike.kravetz@oracle.co=
m
>=20
> Suggested-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



