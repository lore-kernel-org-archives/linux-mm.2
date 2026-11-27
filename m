Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC769606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 15:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JB1zssfY
Received: by kanga.kvack.org (Postfix)
	id 9FDFA6B05B4; Fri, 27 Nov 2026 10:45:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AEFD6B05B5; Fri, 27 Nov 2026 10:45:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C4B56B05B6; Fri, 27 Nov 2026 10:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 29A1A6B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 10:45:23 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABF86C040E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:45:22 +0000 (UTC)
X-FDA: 85481323284.16.D4B47DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9001A4000B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:45:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JB1zssfY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795794320;
	b=zfjDiq4XrXB2iWBwS8oOhMgT0euD7oIkNlDgwU5+AAIpxTQEk+NfYogrve8YWTs6+qGmbj
	MRFNtQSBFEvrNpthi3aLHSWffQGRR2Mmldn4Dp6wzFcd7dIg/mOLFYQ53GL1XLE3l17GcR
	B35TEeCdyD/OZsph8fKfreUaqWlg0eM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795794320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gnDEMS0iHt15gL5KaJ+Nn57X9otTzk+I58v16QdRYcc=;
	b=0YIsK5eKAgStbfqELPQ9qyPHjrCToJW+oCmGg0TeD0h+GF7lb/0jEq5y/Af2axDvfjG1RH
	9OoTMMLeTZxqb+FgylEVT6vYRfBYTb17rBlVdQOWR53W8typtrS7rzQOmVO2ueP/4BRIBa
	9wPCkutkgaGrH3X7wiGwHq+Rp4i12e8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JB1zssfY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ardb@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ardb@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A42DB61F8B;
	Fri, 27 Nov 2026 15:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0664F1F00898;
	Fri, 27 Nov 2026 15:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795794319;
	bh=gnDEMS0iHt15gL5KaJ+Nn57X9otTzk+I58v16QdRYcc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=JB1zssfYw+imHpGzqwtC5bxeRAT3TilT/4N6aggkc/2aQrIFfSKYPjPnNGrDnNuCD
	 i6Q3iaDTFqGIsVtaIEed0I+jvbQmNjOGY0hNBmtE6voI8JTkFcYDjmfcF92t2aRQN+
	 ENcGwC6L1Hmee6FlpOuUsmYvSvvIMUcYf885vMlscaWmV719ZBNjtMUuQus6NE4q+1
	 GuDMExlzxK9s0A0z0wzpLqi6uXoEDtouKh3pCKrlizfJO+Peo0U2usbiuYYHnWVCuf
	 b3Wmdnn8kJMsf1oSSjL+Rjjv+3RkqB2T8knDrwlRloS6lt1DluS9/MFbEx3LpgZ2JN
	 Xe/yFxDspXKbg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 3DDC4198003A;
	Fri, 27 Nov 2026 10:45:16 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 27 Nov 2026 10:45:16 -0500
X-ME-Sender: <xms:iKUJa5AkdJxnKccLXcMCurc131x9BzxkyDtyblVcz7UTk0qCfK6l8Q>
    <xme:iKUJayXFm2YhzIgi9SPInDUX-UJiV53UZOU4RVdrD_eqdQDtpoqTcX_P3iLfD7CKv
    TjTZCJ83aqifQrHscXBVAfYTsDfYsa4nS7m01fyEiM889CWl_Fv8CmX>
X-ME-Proxy-Cause: dmFkZTFMcXaa74Ww3Kiq0njNmC6WTjACVv1LMbtEsqeSpRVSFbR/Ii5MZNWGX9Zt0PDC4H
    QxR9lt1bmXDfrRIrCorv6+5mFL40Wh4Sb/IbRj/BEfQvKKf2rrQS9jZJs2KpQ++T3wSoLD
    HNqyZ0pThIqEcsGyNXKeRbGfLfgvIjr5ltrRA4kRQMAh57Sv/vW40wLB5ugCQoAwYP+yDn
    mqcN6PXz8tAquh0HX0rjDTsI5AoO0CDjNZ9dJZhAXhuICxzq9EfL7Fytc6bGOS0h+qgiFD
    r4m02mBJrAEFL2pn0rfl2R8X7FfezgjnyIqIWsi8BdeUbjGCeYNUokspCipztY5uB13oL4
    YuyWH8KtSnS4uQoxE7PMGHY1LlmlFxxm1KE3zJprK9tqrPEVmOck569OEc4Z34p1jVo+q2
    3ivF3fonc3VfONZur+ttGBJiQPDOFX7bO7YbRRwS90s8oKkKqrAOSAp+bDHExf7PFpN9/2
    MYSpyRRZaH5knqwf1zivHKPr3PkJ8A/L4rbGoWpOAQEudRzQJbmBkT/2j4k+aBm4BxMI8/
    7ie4vqieF2IT3VtbrVvRPx/II5OdY1AE31VoMtNRQFbUR9Jq9KMDKqtqe5GqBnHYYI6KCZ
    Osa26CLih0vjr119q8j7LlNbXu+EoLzZC+4Ve+yd15O4D/joKlh0TnVomAvg
X-ME-Proxy: <xmx:jKUJa_qdFYIe-J18cgVIcEIWWYMT9YX8BlOTTPoAY2dY5zm3U0iWFg>
    <xmx:jKUJawt29v05zGj1N-U8j50ppQcmBWYQ0-C0cQ6JoAXHx8VrtcezgA>
    <xmx:jKUJaz5G7PV1fTi4fQ5s08qRx5AGl_yw_XHl41HZSDv4ismPsQ3SZw>
    <xmx:jKUJa5RQ7EvBTiz9Kx9a6LpxkswJ6z8kJ7JlqwouQwm3fnLCCmpRLg>
    <xmx:jKUJa7lULcOKouAxtdiZ0dgPwmK6qX1xlLeMs44QyW3EBqEInflytp2p>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 5658AF80093; Fri, 27 Nov 2026 10:45:12 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 27 Nov 2026 16:44:51 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "George Guo" <dongtai.guo@linux.dev>,
 "Huacai Chen" <chenhuacai@kernel.org>, "Pratyush Yadav" <pratyush@kernel.org>
Cc: "Mike Rapoport" <rppt@kernel.org>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>, shuah@kernel.org,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, baoquan.he@linux.dev,
 ruirui.yang@linux.dev, guodongtai@kylinos.cn,
 "WANG Xuerui" <kernel@xen0n.name>, "Alexander Graf" <graf@amazon.com>,
 liukexin@kylinos.cn, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Message-Id: <976f1220-a259-4bad-9eb4-ae1cc78a79a7@app.fastmail.com>
In-Reply-To: <20261119082252.9120-1-dongtai.guo@linux.dev>
References: 
 <CAAhV-H5Vse=pKC3Beqhqxa7fqadiGVNqkSy_06HZ3Luw2Pmj5Q@mail.gmail.com>
 <20261119082252.9120-1-dongtai.guo@linux.dev>
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a configuration
 table
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9001A4000B
X-Stat-Signature: n6n4695kjmsb18ktdwn33jofm9epxn49
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795794320-884967
X-HE-Meta: U2FsdGVkX1+GS1bof09ZmH/GOSO8wtxmOZi4hFjCW5iTXGhPUM1JLVR0eMRkr+jzWz6QkIyXyuisyflDaXDX+3WqKb9hdIUduSKcYHWu2ID5Fhy1W1pulNWGMfQgvVE9QflHGmlSTlVmaHW9zIrtTouPMNR53EpOk39Q1hnV0vpu4P5W7wRJ7KNSo4+2x9AK4re5xRt7MkI67WY+LnqLaIaNb4YpALa1vkJewlgrKUBgX3mi3A1RJ/ApsdGIeF+yYhNYxush3oGIaYcXao2Pex8qEtxCIhPBjKy/I2CdM38Cf5W5RkqgpFOf5FsHa2MD3fWWGW7hbqPOt+KSKIVuR41QgX7Paqk70/YJ3+w8DAZvWRliVoGADyd8SKf4FEN5dP6wEc2matBTPv6aHCNibP8wSKnCdLyk4yKUJWwWKNGLoBbAdmmWzU82P4WYTRJ+PRV8umJD1ghooy+NGk+ZC1NNPh7nozKkm6+WrVEs6juDtPPE9V77BNrKnSZMhlIZ8BCjczD51LPqsmvhkAK8Ek3wiizFKPHwEQaIOSPQaPnX6TDYArEcapcnh8UNXnqRPPwbq2L7XkDNJQ/uMjeFRrMqqLJrsUjw3prMnuf1LVFR5qEZ8oe7TbglGV6qV6ckohOphpKeKLL4tIww6CwsP4OgM9ZBYZbJULb+L9Zu9eVhpkSLlyV29KPY8M+Rda/96zw7upNGFKcjav8IghZ7DKJE4KDUi1y1GDHB70nmO90e+7yYpWYtc+5trtSoFMGMF7OZU106L/bqgdpi/b2wKPXK8ZYNZy6sdPDoSnQlTe1NKJclL3nsy0Le9cdEPxBi0ORoccoj7r+Pd5oNpFnrSRIxTd2hpvOpKdNz7XuVGmna6LD7dESHX0NCUqYTcN1Hg+DMZeN4xk3yxahVGiXb23IJYlm7y8zbgAlhufdd7o0amjFlIJmF4WJS2XelKcb8vldozK6rz7fbE+JGMei
 QCQ8LUHB
 9vHTac7ob+e2l0SphwWXN45ZmfdEs749o+Ie4lJ+eu5YRs3xWUiyS4TfiSF+yo/sJYkRyqbTH+I2rDcfxUBMza8a2ynD91GvNfvjJdB+Uxqw8R8pvbUHFKdIXl00UIS7ddwu1ml0dgUn0fsPdfiej3ENRasHZlm5vxxNNZ7/macfv5ENsJPEnYuxFz0pt8rXfmQue91xLN07GOMU7p+/nDK6DxWL62wJjpCSym2tDQCivnIRKNVQigxkn6RQYikpHTw5KRcsnQUo787wjYk0BB/m/bX9JHqc+f8TW6i7kmOgNQxpHBQROEkyuGq0Uq5htVjdVghm+3fly0yhs169RCMvLFB503ME1qXXbYkNm+xUYek+JIfCSf1TBLRdFSlT9Nqb0BBsjTlQcIreeHcAry28luHKDrBJNCe5jJdorp+rQXjtSFVEl4523IoQTGak9gBWdLTH4B05hCGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Thu, 19 Nov 2026, at 09:22, George Guo wrote:
> Hi Huacai, Ard, Pratyush,
>
> On Wed, Nov 04 2026, Huacai Chen wrote:
>> I prefer to keep it in LoongArch until a second architecture, and I
>> think Ard is the same. But this is not a strong objection to Pratyush.
>
> Kexin Liu and I have tried x86 as the second user, to see whether the
> common table holds up. It needed only small changes:
>
> - The x86 EFI stub installs the table, as the LoongArch stub does.
>   install_kho_table() moves from efi-stub.c to efi-stub-helper.c so
>   that the x86 stub can call it.
>
> - kexec_file_load() skips the SETUP_KEXEC_KHO record when the table
>   exists and the next kernel will get efi_info. Otherwise, for example
>   on a legacy BIOS boot or with noefi, it falls back to setup_data.
>
> - When there is no SETUP_KEXEC_KHO record, the decompressor's KASLR
>   code looks up the KHO bootmem areas in the table, so the kernel is
>   not decompressed onto preserved memory.
>
> The table layout did not change. The only change to the common code is
> that efi_kho_table_found() is no longer __init, since x86 calls it at
> kexec load time.
>
> Tested in QEMU on x86_64. With OVMF, the KHO vmtest and
> luo_kexec_simple pass, and the second kernel finds the KHO state
> through the table. With SeaBIOS, the KHO vmtest passes through
> setup_data.
>
> So I would like to keep the table common in v7.

Fair enough.

> Would you prefer the
> x86 patches in the same series, so that the generic code comes with a
> second user, or as a separate series on top?
>

I'd like to see both tbh, but only if it is not too much of a hassle.

