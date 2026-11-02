Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0F1606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bvSA4qb7
Received: by kanga.kvack.org (Postfix)
	id 8B46E6B05B3; Mon,  2 Nov 2026 07:12:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8656C6B05B4; Mon,  2 Nov 2026 07:12:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 754286B05B5; Mon,  2 Nov 2026 07:12:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54B516B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:12:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E05E380C37
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:12:22 +0000 (UTC)
X-FDA: 85390066524.02.3493479
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D737F2000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:12:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bvSA4qb7;
	spf=pass (imf03.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793621541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qjsgSEjuI6q3wyG8cOahzY11PjkthCnss0lk5lbrOPU=;
	b=RPHjcjJKgNHSgoKxjGJApHYRAZd79N8pm0PK+MeGhEexnS2Dl1KRq86i8OkVxUx4qicEwn
	nWB/VqIRcycp/db2GpQBR8e0B60n2gjMxGLuOmsUButA1601vIWVJ/VXoWR1pU8zEVQdZ/
	wKVvOCZYLTJyOK4hJ3PpoC5jz4D7ghQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bvSA4qb7;
	spf=pass (imf03.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793621541;
	b=8mNWYcoRaJbbR6jAr+ZRm1y3Ep7MI2hn0T0qCscwQFVRKx9KiXxHZG2XRnq4ORBKnydwkK
	w7PGbNEYgu8v6K8zW3dgw5tjQdLJ4RWhwqvfmjj1PXs7dibFGnvPXtbheqnRLZ7D1/5Iec
	thkjkTQjO+Sn06GAzdAOxUj4WWsoTg4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 135ED413B2;
	Mon,  2 Nov 2026 12:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5328D1F00A17;
	Mon,  2 Nov 2026 12:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793621540;
	bh=qjsgSEjuI6q3wyG8cOahzY11PjkthCnss0lk5lbrOPU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=bvSA4qb7gaXB+Kqw7+YIinF9/yzBF5H2VDk2RsyxSf9jvWdyS+hGZySA6MBzleRvD
	 I88ODREusmGxL2o4rmZ0xNq+F/pHcAKIPO3zKPHsBYv0bDcKv3BiKN7SwScUf4GPM2
	 cJvQ6QdyyW1zEPvwT3YuaKMU3V/NoWMBeVgGHrBfndngalaacdYdPBeQb4iBK9Naaj
	 OoCnjveJskVMr06bB4teJBn1Avr6BqOQ26NAvCfYyQPQ3+2lOb1M5iofdD9MW0m5Dm
	 ilBIr5cPyWFLnxW1UoTnlqueq0yYA6l8W0yR2VEBsyMkXe0bv9qqKqPtAdXmtrj/XB
	 vH8WC1qc15jXg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 863E5198003A;
	Mon,  2 Nov 2026 07:12:17 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 02 Nov 2026 07:12:17 -0500
X-ME-Sender: <xms:H37oaqsj62gZ143gQYAOk6kR11pQO3q-6lH7_kgbmE32ZQ3LONPbiw>
    <xme:H37oaqSlXPUcE334i4HkAXk-8o3584kmxyygJo78FREAHS-fNsu1ZaRbGfD5Wop14
    mognVTi8SUJpT2sqAi2lWG0m07n7wXtbDQDFcu_ytk9uAvP_39q3prr>
X-ME-Proxy-Cause: dmFkZTFGV+76GMHhPn/Qv6EVmdHDX00lw9odW8bPmFDJPcfjhyFYNuRZQEahF1VGFJ9hn2
    lXt180x8VjZec+s4VdGLoJNNlDAq7Mwc8kSoapeEbrsHIj1b5TAStmu3cWtRGxaZwW3zbK
    dB+L3w0x3Fjnv3hJ89cmjZirPofisz5mY0SZI3yUUpwomKYlCSzvsKRJ0WKdM6DBcPYIdt
    c6Rr7SN4gY0O23CnVNbTrQ2Vs9MpBdQDcVcxLtEDlD2t1gJjyYbTL5jgK9RcI/PsjJE38J
    lyGeguipH5qcq2SB74KuJ/mNogRxJmU+8clkfjKIg+PPPxc7ranAtk97b/mq6tNPBj2jKj
    cUpAguqS1g5DSJtjj7Ue9EHbQzvfoBrH0nJ7tIZxGihsagvjL6NbhGtUqKJF631jCnyS9O
    ZEmjTWEeOyH2hfizQp10erTNnbxcJ3d9ghcWuEy3Y0PT4w1jxTbb8wbtxAzIX/R7n1+K+P
    XiUGq47KDYqns9U8PMlkNcVBNzsVXm1EBlvWdv/Gh3Ise0efbgoyuLc8jFBoVkq1pyfVYj
    fsT1AwftejAVL2RN6egFUXa8J3pEYQ4N0UulGl0voMiQsgS0DKFDS0ZMIs5bjKNSbBLt2V
    0nU9OGioO9L34kPJv2OFdSiY7bd4us5DIMsB9C2oBdmFgEgnDO/fCSwo94pw
X-ME-Proxy: <xmx:IX7oapGkoXM-kSjg5KpMhuLVvAWuOeuWgNTdF-QOkLk80NEiUGcEdw>
    <xmx:IX7oamcpWBQ1b5kpVdtDHPcHu9UR_DHuNa-9iIyOQE1SoljGl6mNHQ>
    <xmx:IX7oaqo4SSV_Thjp8GWinZFCzl_k5N2Q6dL70zoEphDVenrkyzCluw>
    <xmx:IX7oavBaOKTfbCwoRgOTNauPMl3YBUAcDMIeYTY5fsru9D-eFKRTXQ>
    <xmx:IX7oard54v_VZBt-qFtO0xuCCSBiIjwwtqE_VV4osgqugP8LgwKJmSfL>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id E9AEDF8008E; Mon,  2 Nov 2026 07:12:14 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Mon, 02 Nov 2026 13:11:54 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Pankaj Gupta" <pankaj.gupta@amd.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>,
 "Tom Lendacky" <thomas.lendacky@amd.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, linux-kernel@vger.kernel.org,
 "Mike Rapoport" <rppt@kernel.org>, linux-mm@kvack.org
Message-Id: <deb5ea81-70bd-463d-8d98-ed51c316cf75@app.fastmail.com>
In-Reply-To: <f241f883-39f2-408b-9f44-574ce8d2910a@amd.com>
References: <20261102113127.161823-1-pankaj.gupta@amd.com>
 <bd56cfa0-6fdc-4e83-b571-f2abf647afa2@app.fastmail.com>
 <a9fb9818-39fd-4b6e-8998-761bc3439893@amd.com>
 <f241f883-39f2-408b-9f44-574ce8d2910a@amd.com>
Subject: Re: [PATCH] x86/unaccepted_memory: Do not accept ranges that are no longer
 E820 RAM
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D737F2000A
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 7jzcwqtp4pgf19uqso7jg4wsz7hpszer
X-HE-Tag: 1793621540-953312
X-HE-Meta: U2FsdGVkX1/MJEJTqIrOWYsDm3on33BW608cMZg/mmgmAWr0/tmwM/c2O1WmWA1juuMmNrNdptpqAsSoWv8rOhkRVZ0Pb/FT8F21tQyUlaZ2Qs3Lp97KoZ9oHkldOLSRocuLt1Yr2kmnAXD1I2ibGoAPYJjOzqQHyPCfL7V1GIGawgOKZz1B0qkT3zWHTuIs0qsCqCRZOXzJiWPo4X0s4YEXZxJcUc+pUAVxoeLIS98beLCG2qNFg305t65toOm36bVq+ySafBxAZZC8SG6qX4QFvGUJ1KXhuVwvZEFq+UGSm8H5RfkqCJTFaw8w+pNxA86mdNt7mmcg7wJHDt+qKGpk8MUe1acIWmmjGEwsj8KCZvbBCri3IPe2jXv2q3nxA164Yx3SLwWDW1nMHHLLwFhBVdFtmDdpMUj71ozckRvYcMN0Yny+mZIFGorFS2kfx8m6Kr2oygkoL7Z8cmaYshuD+/GiXQSHNIYFkE52/8t638UTxGb8jv5LQliLVZXTmLhSWGQrWNco1MAfaRBBZ0/siLTdKjKae6xKhR7mpwLqYFq+Z+I5sgzHzYAME7UQbPNBgqeoPwmnz7IBk8dS/Fzovrd23UIJ7GLI2c+hd8yIKm6Bszqvq7DrrpwzZPUMDUT2wpB1kPuZqr5lSAZId9JQW/RjZRUmikQvnkpdPUpmmqyj7ILqAMgrYNvGvLcTBfjupM6GKxcyr9p1NS3Uf0U/UYBCll017WfBXTKnQo3mGs/Ju5MAfZwnF7nBBd4/7LFfblNgzVzCg9dDpDxa7QSCv3GAoT46H1lsB5nJkjEAqkX6ngK6KzpjVFaiX1MkI5mOOm4ZQpFcq17KP5M8kELYyZgeqLyGzTmy0D4ZTTyIg1DiPVis6u7GkxwTjm43PF1XF9CRJGqJsg+Th45Au5kejuZ9R6ASKcs7B46bVKEejpac3U/IPOd9Eb7OAuhtyxdb5CFN+zUyfBWkQ8t
 ngnF5DOG
 8rZ3mqITmPZNvLT1i936d5FdUGaEhwpkUl3U4H5dGkseFqhiYNPdwWDB3xftpp77w37hT8qv/JlXuG6ihwCkXE6/RNQlbQuQlVBvl412j7wlY9du8BfiAId3edBl6r8sqEvoufAM/xSKArEoJylx7I1X8o/8P1T0hghiVfBSZYwGYKfQ1yAmkNwae6PdmsKyBjiIR+YrEc9F3ziY14AMXeOw3s+NyVA7UuZg5UBwnLOCpw0R0+2hDtLKR5+tiNu5/Mz1v8RgK2zDd6UhnjvBVJ5FiS20ePHA1kLWdjMy8ARG6PdU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Mon, 2 Nov 2026, at 13:01, Gupta, Pankaj wrote:
>>>>
>>> Can we just disallow memmap= when running in a confidential VM?
>>
>> My experiments showed: memmap itself don't have a problem but memap 
>> with a hole is causing crash.
>>
>> There might be some usecases which are already using this, e.g:
>>
>> https://lore.kernel.org/all/20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org/ 
>>
>>
> Its also good to have a general safeguard to not accept memory that is 
> not marked as RAM in e820?
>

Personally, I think all these command line hacks should be avoided in
confidential VMs, on the basis that the firmware's view of memory should
be in sync with the OS.


