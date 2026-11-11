Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69B91606A88E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=KWOnhTEn
Received: by kanga.kvack.org (Postfix)
	id 88EAE6B05B0; Wed, 11 Nov 2026 06:45:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866B96B05B3; Wed, 11 Nov 2026 06:45:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77CC36B05B4; Wed, 11 Nov 2026 06:45:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9456B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:45:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF4891C26E2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:45:17 +0000 (UTC)
X-FDA: 85422657474.24.F8F8FB5
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 031921C000D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:45:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KWOnhTEn;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794397516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVFpNKJHonPsoU0rKznaV1aSGj2r5pa7n7k1+LB8yBg=;
	b=4F4kZNpcGjI18QWFeRZJsgFQ1iXK5/3hR7PmGxuafWUbNoK4P6J1qns+Cqk1dqqbdN2hDG
	f4Sfa5jnnrepezxD+o3jRhkQBvQ9U2wDlqzJxRzrB0BNWdJ3j2Enbj5VDnbYqXwOUtO2aL
	ZBv3hNbyDO8UoSNDZJPY8Rn4br57Hts=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794397516;
	b=Ws/NtsGXEZR+1mHvM+etXI6l2IU4dNXjBdnyKYm01hSJrN7Xs6UsHzezMrzI7E1N0vmWb7
	cqVQEJ5YvUrdhC0q5FEO3BYEcYm8NTgP2dxFcQTL/D7Vw2T175En/06RrirR6yOSqb655B
	NDW2ctgm+7ldX4DfaAiXT8L7Or2pXVM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KWOnhTEn;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-99c0c1d07feso1385900241.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794397515; x=1795002315; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kVFpNKJHonPsoU0rKznaV1aSGj2r5pa7n7k1+LB8yBg=;
        b=KWOnhTEnvgP4QOIxn/FNRDIubnde20ZOp0JPrfmv7U4mzVJwD2vIhoNAhs8iThKDxx
         ZvKa+mv8MpHXjXc0e52vkp1qEoiGzHctAd6AzErGMm6DhlrnNyIURUFHuD9Er62k/8cZ
         G+UfewRzIouo4omoB4ukH3qP6yPR2XLF/a2EkeGGnHUQ6vT31D7+OCcSjbN2Zj6FYjq3
         kjg7dBxpSauv7nkwTEN716Bxaa3Twte+FeaCPeOpJ8X7QPRRBioWQTVFkHKgLYyIGtPv
         z2dmAYQE1X3zvJvY7VTWe+sQrIMakKZnJrC+TYyI2QZrUy1873E4RQZask0C2MKaL0la
         7l4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794397515; x=1795002315;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kVFpNKJHonPsoU0rKznaV1aSGj2r5pa7n7k1+LB8yBg=;
        b=hYdnrJ69qvtQZ4N/pcR5JzjnwoQ2W3tnlJ8KiE8bvExst0w8n/f23z3vyKW3auytDy
         6KhTz4Ilz8Ge8Wy0u9CTTPn9aTA5y4C0wcYrw36kIqPI0dBEAtHZrTlolQv0VAacBtZF
         RKCQBwH5jWlXSnFdGaL2ETIQcMMCeovvy7k/sjhOWummTXI9LnkPVKFumIXwYnhDVDO3
         fzgsZPox9fXJH3Zbi//L7LhDdRgKIJXpM6OLyAx51s8dLHiBswjt4PN4CkT8hlK9M9dL
         bGpadLb5uPbE0GucjANkBdmfTEaF3mPXArZLiLEg/6rbblUq2iuIbU2cEJh2+ZJCSTGj
         wo0g==
X-Forwarded-Encrypted: i=1; AL+hErE/Ev8uKJSah/449VMIBhkUeCuPqG56kqGp6PM8fp9Q7dx4q5qbaBXj9wQnZLSEgcysGiCJH4WWRg==@kvack.org
X-Gm-Message-State: APuU4Z9KUrixpih2pATbfo6zsiEtMW0g0JYTDcn82BRitcRN7t1FCHPF
	L4kbLJXg/jA0bIMyMq8WhNaZm807z/aNKP/7OYhwtEPKGHTBFlE5OI6vjIyG2iB5hdA=
X-Gm-Gg: AYBFou2J3J4ZxFoHLbwrTwni43vT41vx1VXFXDxuyrI8wRHQnuu/E+E1sFQAa4gjabs
	bJ7nO26I71oUHWZ4wiEZiI2dyHyJDcktnroqtCM8QUfTgOHpthy/jRnUcAlqTG0sYvFITBhhlsL
	TAQAHYBQfJcoJuZ74JkmClwVmKyKHh8rxxYiek1znhQ9kK6uaINBjMB3QJvWYcUGqc8hm5vLXOs
	eBHz6i9wTfTswVaBxsodb8c1aeFAZnogIJYmShiTRyM+9EPBQR428mCPCFBV+NMyJILqTtXI+x/
	Uj0bua8jQ7ImEN5YL8lcmCpUzSRVvFNIhV1/PM8Unav82oGh1EZGzsWT9Y5yDUjCPfZPIIk5tiN
	I+Blul1hTXv7xA/YCCnw7OPqzVqmYkJCstn9Zd2W042II27BcVUblC7i8DSRcfWtGfcr7xjEZRT
	CO/QUMVTVPxksIr+nGzcxSP5itd4tpOQqfERY0pvkffM15EU9uwCW9jxVD7pHnu1/KMkAjaf6pz
	fhoZBqcR9oIV3qEuSL+7Gbup1byGWMWs69EyhCtOyRkfSW3Y22gytv1Ak5W8490+pvsY+UbZekh
	U0qZ7qnAvX6akzqJG1MmfcOlc46TBwqVK1SZnGh/tVH4fKbGJb1QROrlgb7kFHR4cCKnIn1UZUS
	8Mvs/UgPJ1NeYgbLbyvA2q0h42hvzb4c=
X-Received: by 2002:a05:6102:5241:b0:7cc:306:d3ab with SMTP id ada2fe7eead31-7d4efab730fmr666726137.5.1794397515001;
        Wed, 11 Nov 2026 03:45:15 -0800 (PST)
Received: from localhost (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d3023543casm3548860137.5.2026.11.11.03.45.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 03:45:14 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Nov 2026 06:45:13 -0500
Message-Id: <DMSCTXTWCJWK.QF8T3E7OJ7L2@soleen.com>
Cc: <linux-kselftest@vger.kernel.org>, <shuah@kernel.org>,
 <linux-mm@kvack.org>, <skhan@linuxfoundation.org>,
 <linux-doc@vger.kernel.org>, <vipinsh@google.com>,
 <linux-kernel@vger.kernel.org>, <corbet@lwn.net>, <dmatlack@google.com>,
 <kexec@lists.infradead.org>, <pratyush@kernel.org>,
 <rdunlap@infradead.org>, <graf@amazon.com>
Subject: Re: [PATCH v5 0/6] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "Mike Rapoport" <rppt@kernel.org>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
 <179439592040.425130.10808690337075841196.b4-review@b4>
In-Reply-To: <179439592040.425130.10808690337075841196.b4-review@b4>
X-Rspamd-Server: rspam06
X-Stat-Signature: hcnmnpu163i9cjdr4ngsijibdqex7g9h
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 031921C000D
X-Rspam-User: 
X-HE-Tag: 1794397515-694799
X-HE-Meta: U2FsdGVkX1/CzfQTiAymkVEivqQe2Y/UuGe7BjukyvPLcz9PZZA6T00qRIPcZOs8nPWGBgkke7NujnSrDdlg83L7QA3jeYLQazXpotNYRRlq303eWeNT8tq0ppiKmDoDg6t9pOuhoQc942Ce5XXW/DQv8611efNJZAuAeLx5Hn2ejol+cWFHjX6wAucikMIpklm1Gdw+UrBp6oNQUYH+BgL6x8grn3jZUaO4iHamDH37EOGW5+U+WppJuTy5I7qYgsGWwbezCIqKi2zd6AlgUPab8I0vOdn2f08/1Syqq8c+r/U59MQQFZJkwPW87tJpAdqjfpzhj8RENy7hUkXaA7ndKMKKvKDzaN5P9GUwFEaZDVsXppigHUibIyVizy+gEsh7xHpXUFWAHrAMDs7mm2oTrZkNQy99u+uIP9ZKyitNPFi3AFYShs5s0+8oaNFI8Kayiud3xrhr96NF91wwqH1Xxn5ZRySFY32j31cl96iHUNFv3ECgSypMPDf9rc/mf5NcqltcrZRpn/c95T2WDyxgyqZeUOdpOWhsNFB0cGnvOUQcCyOtgPtS61Xwi09mS6a9fUtr04KZ/uRI0ngYv69PflOxIUooegs0WP+bl5P9BYi4JSfwJO6l0vBNsODEUZe7Md7MqRMLYif7Faj4kfiE9Q+Jsgdvj/Vu+0E1nxuMrNc/1U61fUZYo2iApun4a+OwktBtJ5sqlEG2eDUpVqfXe4s1KppDGIxNcdfu0tBZEb5KbDsdhCsa8t9lhIEnV+Ldof3ki36rKU0Fz5Cxxoz34fuhbdRlkrfhyXJlnywsbKDTF4tzf2tiplVfYy5+BvL14dW99kdvX/d/BL5a4p2qGMhqmv9ps6k2DY3eaoAiHyPfwKsUjGDR/StMsB4VP+NI0kasJn4oUe4PiVw9qSKgBWRONP0BkkvI22S03Ct/j+pkUqVk+sCv9dwJgdXlTuZ4Q2IIKSWsHviz88K
 IuGPq7gA
 Vie7HHouvEhXGsnJgXeKV2Uvl2TXIt+vlZFYCkm2TUX17IQmY406G0/EZwzKaKodFjTJiRi4QB0A34bnq38e1Dt+6+6MZAsFPWovaFomYI6PRSypq13sqoRLpSMa6525CeFi2byWiTFLx0uj9j3bTAqa3FGaWL9/JxTIeq+4E8drFJ/qGbBmFNjEGcYQIlMV/Gjod05ik5YscigXEx9DAiWwbw7jh4A2oxsvCKj+91VvJ+yPvma3pvqVyexYmqZTmCOE6+6KF4rg+Z4GfcxBJ8asQQU7VA/yWg2E1b7Cxt9UswBC8kmpM5755hHVteNUtn/f+QjgG5E5x0madK56fyjNnxf3Z48piN0PBtrXItMV7rFIF2VJVaSslO0B09YgM+iMj8Ts87ev/C3c0ybyUETrc/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed Nov 11, 2026 at 6:18 AM EST, Mike Rapoport wrote:
> Hi,
>
>> Currently, LUO freezes outgoing sessions only inside the
>> reboot(LINUX_REBOOT_CMD_KEXEC) syscall path, serially under global write
>> locks, and binds every outgoing session's lifetime strictly to an open
>> session FD until reboot.
>>=20
>> On hosts running many workloads (such as VMs or stateful daemons),
>> workloads do not all pause simultaneously inside reboot(): they quiesce
>> one by one ahead of the host kexec. Userspace needs an explicit
>> per-session freeze point to snapshot final file state (.freeze()) as
>> each workload pauses -- concurrently across sessions under per-session
>> locks -- along with a way to commit a frozen session into KHO so it
>> survives closing the session FD.
>>=20
>> This series introduces LIVEUPDATE_SESSION_FREEZE on session FDs:
>>=20
>> 1. Freeze (flags =3D=3D 0):
>>    Freezes all preserved files in the session under the per-session
>>    mutex while keeping session lifetime tied to the session FD. The
>>    session stays frozen as long as the FD remains open; closing the
>>    session FD before reboot (for example, to abort the session or on
>>    process exit/crash) runs .unfreeze() and .unpreserve() and reclaims
>>    all resources. At kexec time, already-frozen sessions skip the late
>>    auto-freeze step and are published into the outgoing KHO subtree.
>
> Let me bikeshed for a moment :)
> I'm not fond of "published" terminology. We just moved serialization
> from one place to another, why not keep the naming?

sgtm, I serialization it is.

--=20
Pasha


