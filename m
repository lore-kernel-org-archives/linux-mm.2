Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 160B5CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 17:27:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB268E0006; Tue, 16 Sep 2025 13:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6834F8E0001; Tue, 16 Sep 2025 13:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598C28E0006; Tue, 16 Sep 2025 13:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 48C5D8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 13:27:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D93FB58344
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:27:50 +0000 (UTC)
X-FDA: 83895795900.26.A65DE54
Received: from smtp92.iad3a.emailsrvr.com (smtp92.iad3a.emailsrvr.com [173.203.187.92])
	by imf11.hostedemail.com (Postfix) with ESMTP id F3B274000D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:27:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.92 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758043669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TghopMQ1KRQ1raoKz+LtmgTvRmdjxNYmM7uo0zBXdCc=;
	b=sqYlJdoF+ukgUrE3SmrPK4XLFofgtNbprAxPAJ4E0W+Ka0nSsljt+B1zTNUdvM75ofs4uy
	mdv/ScyHF8FyJQrLQLlfxxzI5hrOTnEcuAP5TlGrR8iociyXdsSvxTNMZtw3gzjCXY6i4+
	ERpDT5chMHJaIEIIvZM3CMRJOsK/PqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758043669; a=rsa-sha256;
	cv=none;
	b=Gwk/UjxkbZ7izyQIG/2jQNkigcZ7in5+Xqf9nxNzX63Yltn6qb5F5FkNcLZfELfP3hlgVm
	zOZ1cy8Hxznp3qrtgMdSzRWZWpGAiQw5U2uniKRBkIU0eHiRMGtzjIIpb5bSzPph7Tq+B5
	aRwu6m5jQcGuQvcTigTAxbTtVR8P+SU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.92 as permitted sender) smtp.mailfrom=dpreed@deepplum.com;
	dmarc=pass (policy=none) header.from=deepplum.com
Received: from app15.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp20.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 3490322FF4;
	Tue, 16 Sep 2025 13:27:48 -0400 (EDT)
Received: from deepplum.com (localhost.localdomain [127.0.0.1])
	by app15.wa-webapps.iad3a (Postfix) with ESMTP id 1C360E0086;
	Tue, 16 Sep 2025 13:27:34 -0400 (EDT)
Received: by apps.rackspace.com
    (Authenticated sender: dpreed@deepplum.com, from: dpreed@deepplum.com) 
    with HTTP; Tue, 16 Sep 2025 13:27:34 -0400 (EDT)
X-Auth-ID: dpreed@deepplum.com
Date: Tue, 16 Sep 2025 13:27:34 -0400 (EDT)
Subject: =?utf-8?Q?Re=3A_PROBLEM=3A_userfaultfd_REGISTER_minor_mode_on_MAP=5FPRIVA?=
 =?utf-8?Q?TE_range_fails?=
From: "David P. Reed" <dpreed@deepplum.com>
To: "Peter Xu" <peterx@redhat.com>
Cc: "James Houghton" <jthoughton@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 linux-mm@kvack.org,
 "Axel Rasmussen" <axelrasmussen@google.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <aMmMnfU-Koopc9mL@x1.local>
References: <1757967196.153116687@apps.rackspace.com> 
 <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com> 
 <1757977128.137610687@apps.rackspace.com> 
 <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com> 
 <aMl4qLyNovWHhty9@x1.local> <1758037938.96199037@apps.rackspace.com> 
 <aMmMnfU-Koopc9mL@x1.local>
X-Client-IP: 209.6.168.128
Message-ID: <1758043654.112619688@apps.rackspace.com>
X-Mailer: webmail/19.0.28-RC
X-Classification-ID: 0c2732c6-5237-44b2-a605-baad3a56a91a-1-1
X-Rspamd-Queue-Id: F3B274000D
X-Stat-Signature: 76uz5i7o7uyeo1qbpdf413t4wox79jc6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758043668-606711
X-HE-Meta: U2FsdGVkX18pU6tWs5MtEQqNKQRlU9OmAGF2xrNNSrJF+jsN9JZRNmlTKbmXke5xwOSI7DyFwMyxkchjfumng+Nt9zPDWJaPOxNf0ta50IMqfPpxHg5uwrFKEGBEMooYoQAnUJ9zhszCpL8GBq5jiIF3w242KhbLX0bxanCkyr8vIkxWC/8IrR5bwPg4Uh5UjGmawcqTSl/dRTmW+Hw0CW1he7QdwV+eM699dpGeF8ZiuCuIO7MH/RrVsvDqtaEpe5Omiz22oermqdc0eAt/KOJzFkLQHxboVozQRVcAW13CtfExdR5U9cwoY2Iay7wWeMPx2M9z4wuOmq7atig4n1gHiZi374C4XyzOUxOvF2FPXsHp3tIZddWx1jP2J1szGhA6VX4hak6aU5LCnFS2ZPf9F3n6HqTmOYPJNRiWW2aYbzgX43OUUVe3MStFBlUXIvNC6NqS6sDcp2tN87MVsleeTFAVjl7VVHZYlPNbej3KNwuCFvpyaHIuDiNJ2+IUANMlrQM4PVhi3khIjZWFQJNa66GE7jwapInOZ5GXtVFIK+ibClOFijW8b1jeVGnR1PjteeAGMwOJ7eIR2mXH5CUKcn7gL+80mplMk0GBecpfW81DZN/AHMzCq96d9cwgUUpurr3Fol76wjkcdyq5y9jT8yroXgUM0gX2+m040QHiFtofGzz9uZ5B9yWEBQ62jGykwZBR/n9lXAY+3j1JNgku51C/2Qy0ceI8O5WehtEQ4EIjRGyoF7Dzg4+cx4+Ll/9gMxxOxhAYUQU0AvWVpABd/Owh4bb24jMwBse9bgDGCHEsru2OofmZYun2DIHlrBt1A7eceBx9AihgLJaRMP5V3pniggL726dlNL7sOkU9URxLOYxh6nBcayuQIwW/LjEihlj1rOPp5/dg5Uu0M6gzNINvTYAbI9+bh+JWVNlLH3HDDgcgLk5V3+4sToPcRMdosy3X5mmDNcXE7uS
 JKx4frzV
 bfQlH5NTvZEkOvFbaSizuwZL0WEud9N28UN/a7Cl3S7+K1hrPTuhTfkjbE0eDbgIxO7Z+mb1C9E/QWBA8tlB6hFhf7NlxndnjA7npJbkUpz/IyzZ8k/Qv7hClUdJhF5c7PzL0ThuEFtfIA4/jcCPOFrcvAt035HErPObx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Than -=0A=0AJust to clarify - =0ALooking at the man page for UFFDIO_API, th=
ere are two "feature bits" that indicate cases where "minor" handling is no=
w supported, and can be enabled.=0AUFFD_FEATURE_MINOR_HUGETLBFS and UFFD_FE=
ATURE_MINOR_SHMEM =0AIn my reading of the documents, these seem to imply th=
at before they were added as new features, that MAP_PRIVATE|MAP_ANONYMOUS m=
appings were supported, and that the "new" additions to the MINOR mode were=
 just for HUGETLBFS and MAP_SHARED cases.=0A=0AIt seems odd that anonymous =
page faults and COW would not be handled, given that context.=0A=0AAnyway, =
that's unclear in any of the documentation. This just adds to my last respo=
nse where I explain my use case.=0A


