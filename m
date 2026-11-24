Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B913A606A332
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6L1RhGw
Received: by kanga.kvack.org (Postfix)
	id B99A06B07AC; Tue, 24 Nov 2026 11:26:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4AC56B07AD; Tue, 24 Nov 2026 11:26:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A394B6B07AE; Tue, 24 Nov 2026 11:26:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4FE6B07AC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:26:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71E0C80B4A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:26:47 +0000 (UTC)
X-FDA: 85470541254.11.8337E5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6594640008
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:26:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j6L1RhGw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795537605;
	b=EQ+d23TiVaqI3OESG2FL5rjHZstImJsCF1Y+Zx/DIv42XqwN0bDX1Tev6IUCdLSgxNEAdj
	eZoz6YMPTof9vvgtresjH1ja0Rnxl5HZM267cQUmAisJNwq0HUXY2y/dhgVNIORJULT1dN
	6OWeYJ8Wcnku5HS8GEX/6XJGHpAcAUA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795537605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ieuTKgTmupFxrU1Sy9W+USlkxgIOvC38/mQnd0MGzc=;
	b=Ux8DvA6NFBuz4i4sU9h48BRediTw262AvIsJuagIHEeBWM3DQb0lgfkrWWyTnHkD7Mzc0x
	V+JPFkXbSiv1cWK14YG9ESzn58yvNxPlLrWIpTaglMF6A1CnAcwsCf5TwofXcwk0GpgxIs
	qw02XWlQ6cAmEFTFoMhzXYVm8trmLmA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j6L1RhGw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C830456DC;
	Tue, 24 Nov 2026 16:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254691F000D2;
	Tue, 24 Nov 2026 16:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537604;
	bh=3ieuTKgTmupFxrU1Sy9W+USlkxgIOvC38/mQnd0MGzc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=j6L1RhGwQsaoRh1nVJn7PuNzvakza5gtaiZLoJq/m+IiguPyeMh3cS3fZfGdgtGlC
	 15ya3i2ujfvmTT44rx95cBNQn3F/KudsUYbdNtueakfQ0ir8Oz2kko/9ervRrrbQys
	 Y4OYIPv1aljxchEfsLZmANOX0wgsnTyR/p74kcdvopIp4Rt8o3kvYV1a4jW2lS6Tpg
	 wCNly5fKgf/CVUZzfp/413J3/6ya4f5XjvqESi090BRzjcgxTqY1YPW/ybVFOfAhRG
	 BZPhoBtQ6TzLTciE+qUV85eCVQfBfdQuyZ3X5lLqMJtESlFLjig3JcWsKVc1UWD9pl
	 PWV3HJs3Ujjhg==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 64DFD198003A;
	Tue, 24 Nov 2026 11:26:41 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 11:26:41 -0500
X-ME-Sender: <xms:vroFa1iKzJcRFma2WR9T_8ifmTKzYiLTfc_pGVsghlMf9rOWvhSqJA>
    <xme:vroFa03LEBspPgahUh1xWn3UWQP1ogEsYVLwahDfURdKV-i6Q8XfyX6FtotFDQGpZ
    _BlhJXdIhHZlDXwjiXDKNxeTSlMGumKl1_eMRRfwtk2NouMbKBYqAo>
X-ME-Proxy-Cause: dmFkZTFK1SRhx2fcvvqjUveP2099rvc9Qqgqkm6zs8iZkfpV6opMlmIptApe4Y+xP/FpCz
    ze1RuYawTba3QUB6nX7Y/xW7wxSLien47DLY7uc8GeZFx24VJhLiBZGZPb96x/pDRAU3iE
    4tktzZrZoaIXvZMzKB62mZf9XuuMFTNKutvX8uOtieZ40/qrT7szA49zcuuuXJHYjtQh7y
    ZOA6Sl+gjtYF3XxDxQ8chsK2eEk/eAAlU+yQmdUANx4B+IpWxavF4S/8tBoisLFGAbszDX
    FPUX1luYY6i60WMQq6hQDK9NwAcU1umwoSULVAGjpj1g9U7BKWyorky4VSd4mPYl0pSUtP
    ClTuwjEaarOCEy0WwSVwsrE9WtA7HibLwLn2lCgLyaHlaT1xqwFZZUZmv2CBk8oSyQg1hi
    hZY1j+b9FROUGRItxhIHzKNo30zVZF/hqyMwnwNtallKr3uLdE638aepUS5bRyMCdDmNqs
    8B58vNGUZ4Gtl4W6b/x59i2f4hqND6y7QKGWvdPSC+u5QqaihGPnnOuJS8xtucvntG76Qu
    qaX5jx/on0/xvQH8Dnn9N4x2HTl8fp7Pt2yRplUf2DUDMtn2VPQp7TVXRsEHERJiL2jb+M
    8Dq8Fa8xLSeOuc4lfGbo3i2TAIsyFEGdB0hEEiU/CBe1OQFfIhqHXBcTy7LQ
X-ME-Proxy: <xmx:wboFa8dqwp3xU8riLhiiS2MPpLKE3ocsL-ZO8_WPAlYX4DX7uOQMDg>
    <xmx:wboFa5FcJk-n5Yx9uoDR2iw8DJk_zpFiAehd4yf5gV-MHpnt-t1AtA>
    <xmx:wboFa3v7kQ_dyVuuMXBQ7NPGnhA_rwJDM9nxd-PbwXzw714Jsds4dA>
    <xmx:wboFazrTexgvGU-sWY3wiHdgl5zrUGFxJNStw_GWwNPv3i0rYXDMnA>
    <xmx:wboFa-mJL-5AF4zgmplLqLwhcoa44kTPUMNvfInOskBrDJ0RXPFdRGoA>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 7C79DF8009D; Tue, 24 Nov 2026 11:26:38 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Tue, 24 Nov 2026 17:26:17 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Mike Rapoport" <rppt@kernel.org>, "Dave Hansen" <dave.hansen@intel.com>
Cc: "Pankaj Gupta" <pankaj.gupta@amd.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, "Tom Lendacky" <thomas.lendacky@amd.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org,
 Pankaj.gupta.linux@gmail.com
Message-Id: <c0e82936-9436-45e4-a8b6-07bdaa9680df@app.fastmail.com>
In-Reply-To: <awW31hUpXuujSAXA@kernel.org>
References: <20261124133241.221719-1-pankaj.gupta@amd.com>
 <e08f2321-749e-40f6-9ed4-3dba8e1625ba@intel.com>
 <awWzrkLxfQ2_ODKe@kernel.org>
 <2dd40d0d-2e1f-4a7f-ba65-2cceccd82028@intel.com>
 <awW31hUpXuujSAXA@kernel.org>
Subject: Re: [PATCH RFC 0/3] x86/e820: Ignore memmap= and mem= in confidential guests
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mh1by1bhup16gjtg9pu8kysbwg9qq544
X-Rspamd-Queue-Id: 6594640008
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795537605-690762
X-HE-Meta: U2FsdGVkX18aX5GDeSeDwL3hzHGGwRhK4rLp7CDPz5OnoFla/okXbhALMX0rMqfbo57ZmEu4Jgm6eyBTFzzE9LSL3fH6Z5N7bqQqcL2ou9RdQ9Uq1aeoXtAZsgDklj196WOPoq91WhvYrv6sh6S05A9ctXPPXzn3YPrcaXGYNejofi141qjy+mDCbbHtRFT8ZPcWo3NLwix5iBG1iXfSzcuWxRj/T53JRNZXbAccea35zmFzOv6tp5agPQANVGVThpsoZAFNIri6IOYf2UOBNF+KUpDkumKKWuuyO0CT700RFq7T2H69pZnmM8NBArslKzziTUhftgECNI3TtXrhWiMQiKC99E3lAmPXoDp4YHOaQ5saUxpwhzzEivL5jYVhq8tCMy2Tid0aR9nbRcemutDfawtEMnEngvW6e4isZ87K68mrs6hO1ukaPh6cuhXl4Is5CzNUVyuuPNpmXmnOkzpayeEUgK1P4a5EIxh8yho+91Zl1vCid0pLfPSSrPUY/Es9ASNopluPoejWMywhR8hDVtbr8F+CcUZ8RsFz+sNaRcPfwRMhQ3TSmd0F4YIvwZLa34Lqes6H6Hnbt5uJx9/U/DKHTgQZlYFQ0Cf7MxZkYguthAWqlo9xoKKMq5U4xdz/UnMWPHkLPgHp7HgiUA2y97754qzfGts8Yy3q7kzM61p9kc6pJqyf1hFMD1Edc1WiiUJrEiUQEI6kQrYjOgRWY5OWRb0E4FjRrlA/cFKhlSa7GQ1RS9isIoZjOZxAbNGWIlIh31FNJ0Rseu6H1BF6k9tSCkowt+JYPTU5HWkYh2Hj9DpKN5iet6pnNSewopBPKV0wrrHQ80ZJwbvpV2HU15un6khhhlULjKLvhkoph7pijQXzrgh5Yy3fl+gYnwqSffO3p752JOiURe6JDx48F3zMw1ucfb2OhFApR2RFotnGRpcWUi6bTeehVeN6qA4guRA4KI+5C6ZMBML
 oGR1GQhm
 bpf34oFNl8dLj3g2D328OJ1BLQc+DrKTO3OXsdsHaLxW8Ugfz/S+wQ33m0tcvoP6iqUygu7CvuKUSwwvZuu6kAkxOOxKU1KRqZSnCWske3cYd8ROek0gT8HHW+fA11LX5gyQ+07ok4SkI94dJ78QT3Fr1R4X8CuLlpc0qhrsQ3xppS4RqTCcmcMCH8KbrnFDycMZU4OU9bej6CTvMprMSsRJBRtHZ3tUOwQJ16nS5crOuCz8ao2/j2xpmnQPEif7rCA4+iqkSAawRepI6+qjewPR/4wdYbzMB62usdYJeeEJAVBdu2uyGDLrHEQRxa2NhXNKMqaE+MSyn1/R7Ae5hvgOqWNCrzh66mpZCiKsG5gyULSK6ceIDgCDubYafkZkOKMUjnQAA4JDij7pi0ScFoau0zaq5V/LLdrns4kNPEIvJiGkdnG/JLgjlORqfX2u4zrZ8uIjJgS1tkz61T9RTKl6H+PVFFygAG/iMSWsX0ulqlAcp5P++erbVRntKIZ22qcek5U34fWgHOS+ITza1VkMKjancgkTpdaZxhx5rJWwn0E0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, 24 Nov 2026, at 17:14, Mike Rapoport wrote:
> On Tue, Nov 24, 2026 at 07:58:31AM -0800, Dave Hansen wrote:
>> On 11/24/26 07:56, Mike Rapoport wrote:
>> > On Tue, Nov 24, 2026 at 07:09:42AM -0800, Dave Hansen wrote:
>> >> On 11/24/26 05:32, Pankaj Gupta wrote:
>> >>> In a confidential guest (SEV-SNP, TDX) the EFI stub builds the un=
accepted
>> >>> memory bitmap before the command line is parsed. memmap=3D and me=
m=3D edit
>> >>> e820_table only afterwards.
>> >> memmap=3D and mem=3D are debugging tools, right?=20
>> > I wish they were =F0=9F=99=82
>> > But AFAIU they are used to carve out "pmem" or PFN-mapped memory.
>>=20
>> I've used them that way for development, but production pmem systems
>> always had persistent memory in their BIOS-provided memory maps.
>>=20
>> How are folks depending on these in production in confidential guests?
>
> They shouldn't but you can't guarantee that.
>
> But I don't mind letting them crash if they do :)
>

I'm fine with either approach (i.e. disallowing it or doing nothing
at all), as long as we don't pretend that this is something that is
expected to work.


