Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 459C060AB736
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxbox.cz header.i=@linuxbox.cz header.a=rsa-sha256 header.s=default header.b=Hh5PLXpv
Received: by kanga.kvack.org (Postfix)
	id 6FB276B02B0; Mon, 19 Oct 2026 11:23:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2676B02B2; Mon, 19 Oct 2026 11:23:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60F456B02B3; Mon, 19 Oct 2026 11:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3A0DA6B02B0
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:23:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0393120754
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:23:02 +0000 (UTC)
X-FDA: 85339743804.18.F4B5F6F
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf08.hostedemail.com (Postfix) with ESMTP id EB32816000D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:22:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=Hh5PLXpv;
	dmarc=pass (policy=none) header.from=linuxbox.cz;
	spf=pass (imf08.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792423380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HvJ2kFVuvGS7ZT5+hoLkozBmLJcLaDkGg+Rc7WYWmE=;
	b=Kwm/FTaUWCRnOGNvNphkn71qYHF1/Ag0mJ3bKGHvAWEr+GEfRyBVJdB83Y0qKtCasfg2cT
	N2f+ONl9OA6jhMawasl2YxcONYgCLqWofqHWRCDHIN53HIe7PQ6ga9xInyE4Cfe7+KT1M2
	7GpFGc/9gAazkdb0X5nfijzEDXiQHqs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=Hh5PLXpv;
	dmarc=pass (policy=none) header.from=linuxbox.cz;
	spf=pass (imf08.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792423380;
	b=RMaGJ2QERfpA4fPp3PGJwuKD4u9ruGk99eX1QMWjgAfMFdNk1PjlfO1NS+EZjlFkdHuBDC
	SHmpIvqqW+oq8mOKLUxRVtzwQnLbLmFNjdnJ5QrVmOIIGHU74/skK/fyO393bZHOSFnOV/
	dtZeN9Moo0EsqSG37M3e9w95EqByUGg=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 69JFMfLC1208580
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 19 Oct 2026 17:22:41 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 69JFMfLC1208580
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1792423362;
	bh=+HvJ2kFVuvGS7ZT5+hoLkozBmLJcLaDkGg+Rc7WYWmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hh5PLXpv5/rcoN0VZaOLprddInBoOxdrtKPj8uYQo+VzSQcyZAU2ZNQ3Kqt2My1qX
	 /520Dy+VoiNeqPY5l/1x2zlBC6dLkRDxm6cGczTHN8N8Gr4biMl9ZkZKfHFtPNJR/M
	 AxZd75YD1uEaQr1hKEINql/b/YbZC2nZett8lwHI=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 69JFMeGg012171
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 19 Oct 2026 17:22:40 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 69JFMbH63191394
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 19 Oct 2026 17:22:39 +0200
Date: Mon, 19 Oct 2026 17:22:37 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
        David Laight <david.laight.linux@gmail.com>,
        Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, david@kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
        luizcap@redhat.com, pbonzini@redhat.com,
        Tal Zussman <tz2294@columbia.edu>,
        Matt Fleming <matt@readmodwrite.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <atY1vWRBRUwpISKb@pcnci.linuxbox.cz>
References: <aszH4vpXFAOQP1WG@pcnci.linuxbox.cz>
 <20261014235736.GCatAW8GD0GlYumL4l@fat_crate.local>
 <20261015172820.7961d2c0def74d41cc6c4b0c@linux-foundation.org>
 <20261016031242.GDatGWKo98YSOhEOOn@fat_crate.local>
 <20261015211832.45d87fab15bb3e0bbc2f47cb@linux-foundation.org>
 <20261016054954.GEatG7AgMNFRkiTo1H@fat_crate.local>
 <atI_yuCc4BiweBQP@google.com>
 <atT5TYyLapHO5ZoX@pcnci.linuxbox.cz>
 <20261018201538.d0957878f378a9821852836f@linux-foundation.org>
 <atXXma5NXxoSWJO0@pcnci.linuxbox.cz>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <atXXma5NXxoSWJO0@pcnci.linuxbox.cz>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Spam-Score: N/A (trusted relay)
X-Milter-Copy-Status: O
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB32816000D
X-Stat-Signature: 6uezyg3yj4ahjifxagkmypgytwe4g3na
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792423379-237211
X-HE-Meta: U2FsdGVkX19U/9qTOs/fcnqBcMN7GrXC3NEgF4vIF1rMK+l+fd69WYNWqqPdELeJyTCUtjB4R56G+xmMumqlMl+g71Z/3/yYKbuA4Z3dMHnuPKlzCMlv7PqrBc4OVhlAj+Arndt09qdW7hWAC/0GjzEEQw41OfsOPcUBwzD8EamTTb4tYHSBH+KwH3dsDy3XZiBkQBJ4cNExZVQd0gH5vcnbRil6aBmws8/KjceCshUScIu0zvGKOabCIG8JtNaHCCvZXBj61NtCYWS2lqPbobW+n0wrNMUpDhF2kbR0zVODLlTkQgC0G5fKVQTA5QHQK6d+Yx8RITPI+w8TPyOWVam4YWp5egycSBYn6DNYPP+mowlV+YdPM8UhPECG0El759Hn2/I4YogZUOeHmMDy7bJcGQDFLCjv+4sLF9ZlIISYaeKTEy13Uhc+Wh1tYAJUdYxBDdMduk7k6voxY+6UYgriROTCi3h7bCDvId/kZJ6csoyvuR9j9Sa7A90fprCyS+B/SfQeADlRQ6y3NW3u1mSnX14qoSAZymFykMJpPCcKXep1JgG4H17msHN3DxLEumxa9eHikz3M+zxgXgOJMyHDEyY6jDqpFWGAghaM9EazyTSMqRig5Vz0F/5Im4QHhvvy+7ZsHdN8Cd7AhPYhImRsL7YFItg73ywyF3IF0qDI1SH0a+9OhCbStOyboL/0ZYiYicVtYnUve5I5hOIbGz0EhpGYvGTkbg6qFINIbuSi022fXreNDG96oVQ0grzITwGcJlXGJTC/bZPmlbNiD908i6M9+WMas7as3GYnqsAIahWyF2nCnqajJyiYT7JUdLh+DygsJYErbY7fkVlHWLTwv8FyHGtkYuZDLuITfVBPZU6KSjN+RENrvB00PdWhPyTBkgtsm96dfbPRnHOlbU9j+f4DRFllb7Wi5xsNngIcbQaO9XAOi6MyrIlurf6OU5V/rNYCLPhgTqo0NoM
 t3NrLHbn
 PfrurR0m7AM4PUwy7ftrh47VyjSk3DVji5E53P/XsJzpkoNRN/M8nXHE2ZnKwccbuVbhN453icq/IwWpf2+1/CoN91M1fkbxPddBlYdFVSXcdfK7tHKGPqYIk32NNmNZYyMRDvs9GOEEvhnCsDcu0KRK37XFzlv72TmisV7TZwOPilNaOmZrrR4JEy2b8c23CaJUl5+HURMU0rP14fMjovr09m0xLWXByLkXmq9Xfmzw3Hfcism1P6/PYHD/C8n0zX7qWN1slnx6u9OS5xI//nH8jTISx2E6r2hel1TsII/ziQ3FAJjnupQL3Vpew7KOj4oJrXQOWl5R07JyohHxhh6Pho42ErVK1qYXEr3pCU3GygKlZmonteMhmmvbU9zD6JK1y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> 
> Sure! And I have more good news: after applying 55780d8a1dcc
> to 6.18.56, I was able to perform more than 30 migrations without
> a glitch. After booting back into 6.18.56 without it, both VMs
> crashed within 2-3 migrations. Furthermore, some memory apparently
> got corrupted on one of the hosts, since various commands started
> crashing too:
> 
> [  303.466091] traps: systemd-logind[3085] trap invalid opcode ip:7f7b5667e616 sp:7ffe1afdec38 error:0 in libsystemd-shared-252.so[7e616,7f7b5666d000+22e000]
> [  303.493810] traps: systemd-coredum[11269] trap invalid opcode ip:7fc6bf67f614 sp:7ffc075da958 error:0 in libsystemd-shared-252.so[7f614,7fc6bf66d000+22e000]
> [  377.528955] traps: systemd[5607] trap invalid opcode ip:7f791447e616 sp:7ffe83e61cf8 error:0 in libsystemd-shared-252.so[7e616,7f791446d000+22e000]
> [  377.556993] traps: systemd-coredum[12080] trap invalid opcode ip:7f97ce07f614 sp:7ffe28b56a88 error:0 in libsystemd-shared-252.so[7f614,7f97ce06d000+22e000]
> [ 3746.173043] traps: hostnamectl[45846] trap invalid opcode ip:7fe00cc7f614 sp:7fff89916e48 error:0 in libsystemd-shared-252.so[7f614,7fe00cc6d000+22e000]
> [ 3746.202305] traps: systemd-coredum[45847] trap invalid opcode ip:7f7fe9e7f614 sp:7ffea227cfa8 error:0 in libsystemd-shared-252.so[7f614,7f7fe9e6d000+22e000]
> [ 3750.581940] traps: systemctl[45903] trap invalid opcode ip:7fbb8967f614 sp:7fff733e5748 error:0 in libsystemd-shared-252.so[7f614,7fbb8966d000+22e000]
> [ 3750.612651] traps: systemd-coredum[45904] trap invalid opcode ip:7f90d347f614 sp:7ffdc7f55148 error:0 in libsystemd-shared-252.so[7f614,7f90d346d000+22e000]
> 
> I'm not sure if this is of any use, but I collected a vmcore of
> this state by intentionally crashing the host via /proc/sysrq-trigger.
> 
> Anyway, I'll give 55780d8a1dcc some more migration rounds, but it looks
> promising.

500+ migrations back and forth, no issues. I consider this solved and am rolling
out the patched kernel; I’ll report if anything new turns up.

Definitely a -stable candidate. Andrew, will you send it to Greg, or shall I?

Thank you all for spending time on this!

BR

nik

> 
> I'll report soon
> 
> Cheers, nik
> 

-- 
Ing. Nikola CIPRICH
technický ředitel

+420 591 166 214
+420 777 093 799
nikola.ciprich@linuxbox.cz

www.linuxbox.cz

