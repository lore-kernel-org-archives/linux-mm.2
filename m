Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27CB606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CvpqEnSe
Received: by kanga.kvack.org (Postfix)
	id E0CA36B0737; Tue, 24 Nov 2026 10:02:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3496B0739; Tue, 24 Nov 2026 10:02:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D207B6B073A; Tue, 24 Nov 2026 10:02:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1EEF6B0737
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:02:04 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A235E140BEF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:02:03 +0000 (UTC)
X-FDA: 85470327726.08.0DFDE72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 24FA4160013
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:02:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CvpqEnSe;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795532521;
	b=fZlau8lPrXMMImpDG50cfGQ8EFio9U6oCA3Sn8pXsvrhfjjaoN00hsNXwZdEglT8a3TbQQ
	4UtGnsNmQQhdxgwPB4XZR/th/X6LgVnWRuLObBnM+9CCYvUwbB5oIebsz6bJLbDGZaSIN1
	WCRPE6zc99Oal+4MNcJrHRm5jPBD0v8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795532521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bpN98SL1MCwWUh8dbQ9cdj1LeUak/IvNk2HcKSVXVCU=;
	b=JmWDjWVPNWzGcyfaS6XwJRWOrQiiB3QWxmUa2iX0b0ER7ruOBe1Vnwtsvt6PhWOd2mw7w0
	hrmBJq9rkg1q2AMacn+l+tgyTcijV1F00jBluLDT1R4V3GZC+FTUzXi1+Y8gF1iyBiR04O
	rxdtkgqxvHR6Gq0wJKpbv/sp5T/62hA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CvpqEnSe;
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 58932626E4;
	Tue, 24 Nov 2026 15:02:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46441F000C6;
	Tue, 24 Nov 2026 15:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795532519;
	bh=bpN98SL1MCwWUh8dbQ9cdj1LeUak/IvNk2HcKSVXVCU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=CvpqEnSeLHdFWrDFKh4NESXYRXxCNwsUxH1ZphnZjzzbCIqUtfW6dlKYZGajy8KQk
	 RfX6y0ZICxAhtoFbDmsWSn8mWAtDMJO5djVWCae7DM0njZOPcxAnbVRf7hwteiRjL6
	 v4WP+z2OLTf9dT8LohKTNHFGAvFEZF8vkxsqSiIJJO+IaBPVBwKat9UIi1tk7NgVww
	 fyMQZRSt/jhG0yxsupW2BsSVIR3ythnN1476qB+ZvbJJIUM0k40Hnb73E1h50dCuqG
	 UkfjY5pWlgVb0OQ3D7ZXZT6+h+hl4TRSnJ7AAAHBI9DtV0Uktm2+YeQUj5mBZEru+f
	 MEzhXdmMt1Jvw==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Srivatsa S. Bhat (Microsoft)" <srivatsa@csail.mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Baoquan He
 <baoquan.he@linux.dev>,  Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Alexander Graf <graf@amazon.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MAINTAINERS: Add missing files to KDUMP subsystem
In-Reply-To: <20261124-fix-kexec-kdump-maintainers-v1-2-79c6a6144de4@csail.mit.edu>
	(Srivatsa S. Bhat's message of "Tue, 24 Nov 2026 01:37:54 +0530")
References: <20261124-fix-kexec-kdump-maintainers-v1-0-79c6a6144de4@csail.mit.edu>
	<20261124-fix-kexec-kdump-maintainers-v1-2-79c6a6144de4@csail.mit.edu>
Date: Tue, 24 Nov 2026 15:01:56 +0000
Message-ID: <2vxzbj7ez317.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 24FA4160013
X-Stat-Signature: o57g5y8hz1jxob8yrzgin5jyr9eqcjkk
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795532520-35533
X-HE-Meta: U2FsdGVkX1+Q7JJi+sSgRxiOvHbeYV7N9pS9hh7cn2aOQuxU4ZSlZ460QfXl56rJKGxL5IjuK562q/5bpo0/wBVyb1ePI2udsi8o0L4GBIWJB5996Q0YP3YG1bQYTN7xVAfGPO1FZisEk8R4HjPQWNYP7b6dIbO+UQGx6IXtFGBFpjpu0v5/sLAaq9nUegn0iHudGDHrMyhhvqhy0aZgm8gk8r35Eg7JCw4Fwywf7UdXZpE9CkEust9M8inmkXVEpXd8OQS+68C+zf9X1EcNC2iQBIOPSI4CMq1AAjFpnuL+ahvSCiQNPT5uwNVEM5MDMBMWjCBf2mTEF12XqMQdap1GxVMK3HCeyAqncptBT2gYzZarYeROrWD3lyBDpWdld0x4/EjLRvujY1MtcofwUGUyKLnd4xmJ0IaI+x7mU4NUD9SOi1UISOMSudDs/sTOl7Bgq1+xrob8zSXyyC5LqDHHYmVuyTgMxtCAMBhp97Ykmftphfj6lGJfiLgxib7jW71ORLu2xrowlXoYj7yYxdVAfnX8DnjrM+mx6wIqusA/41BfFtUbx9m8+PEtdlv5CIDPmwm4R6HueJ0+hdWUEU8l0W7ODm2IV9rBPiWpt4zkH8HUXVC4ew/YAm4jYJG1BiuIQdZyNJmbEDrQIpVZaV91G5TInzuR3WMvRLRAnj6k4W82ntdTfC2wHkmTrGrB/1Df/1jKa/i4+aBL5KK5PrxOcm6ozrJASqQI1zVysi9p66apuMglSDiR1leyq45t+F0B0EDGd3AUnSQrOGvtW3j2+fqxi5IJSYg+Scdh5JbM//5bcq1q+C2szRAO3gibED5ctFvQPJlHT7qBZvBjT4n//eaaCA6ab6IbJmOut/T4Tc7SeV13f4TWN1g5i/tHb6zj00bpgGgTLEgtlDwgv5aerIkfAAarLaUp2xF3rpJkhUNbEE0CilpR1k9g+/CybCp3TWqBb3/7hzSBorx
 DqFCAq44
 iEkmvSAPy16cej7n7fquj7i1ZJ7ivyQJK2KE28xcvFZ1DNP3sNYLpROiDZOH0wGgiljylYsaDz7FkzLC+LzUOWaeE1VXLdtHdc0dx53fVhL+wFGg4uwwBb4mHrkzQG9xDIwas1FuOIV9ijg9k78OqhZkRvmL8jHx+esN72aPrg9zHAiPFYgkET3r7ZJL8IFcyYy59dhDc5ssIWloSdn8va1lnx2wd+7ww9rvK22h2h64XA6t6OHVDU/TcINCOh8HpdXRpWPM18pjlipDr9KJ9V5tWEqSlfjDJcw0v1O5/3FR+RkZJQxWliC/RficwIL/h96UmoSxkvVp4/3v70C1wlUN9LdOORwobAsAT8BNjEeKYofWkdFM4arjnbV/OMOWDaxs0OLP5kPOv/3513jNq2cZr9bxIYB0EkOOs2QDNrtvZwT22P6ls3FVfnN7h8YctgjTW48f0m7AiIMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24 2026, Srivatsa S. Bhat (Microsoft) wrote:

> The KDUMP entry covers crash-reservation code and the vmcore interface,
> but omits the crash-reservation header and the vmcoreinfo implementation
> and header. It also omits the dedicated kexec/kdump and vmcoreinfo sysfs
> ABI documentation.
>
> Add these files to KDUMP so that scripts/get_maintainer.pl can recommend
> the subsystem maintainers and kexec mailing list for changes to them.
>
> Signed-off-by: Srivatsa S. Bhat (Microsoft) <srivatsa@csail.mit.edu>

Thanks!

Acked-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

