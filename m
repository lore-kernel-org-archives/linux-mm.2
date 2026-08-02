Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA20BC55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 05:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544726B007B; Sun,  2 Aug 2026 01:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F50B6B0088; Sun,  2 Aug 2026 01:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411266B008A; Sun,  2 Aug 2026 01:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F423F6B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 01:09:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A9BCC042D
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 05:09:56 +0000 (UTC)
X-FDA: 85055152392.30.304F889
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2814480002
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 05:09:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RVJxx1S5;
	spf=pass (imf02.hostedemail.com: domain of ruirui.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ruirui.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785647394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hd4cL7pghs+u2caiYGxcAzT0GxJfEgZpykZQLSOMKeI=;
	b=ChNHAAGERFdrdev3JAV/u6kdDCC8FpZA0H7d3hgDA0FqcqbZ5qR+z8e75aNTCn6YBpHuIo
	eD5Vje7UnpnfrIXiDIcf9VG3KOsVv8qGUB+0h5hxIM2Pq/8nUeF0S93KUYtyfrmGtNVcWp
	r4/7UeSozFb5xmctdf0qfESEC3znImQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785647394;
	b=mBe1BrFFs3EI18b4cRwWTa4FJTFGaWWMZqDSUxiLNgwU8NUVliFKLSANqAZohfJsp5YAnT
	hNw30TZTYLuZox2iy0SNV8KGqT6ApERTOPT5MgOr9mBvXrg4eSaypqb2tTvlc4UrPK3cG5
	4fWK+roWTFeAzMj4Wigv/Jy/PGhtLz0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RVJxx1S5;
	spf=pass (imf02.hostedemail.com: domain of ruirui.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ruirui.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <79610b53-5201-4af3-913a-0c4dcbb6f9d6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785647390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hd4cL7pghs+u2caiYGxcAzT0GxJfEgZpykZQLSOMKeI=;
	b=RVJxx1S5DRBGBvjVn4pgA6hw3XqP4M3aArDWpSdUWbhITIKpirzqFnYKE0ULdaBQR9D5Kq
	m6JkrqIjl2xpZoauRX3BuZJw5k3oj8Kog59W0gmvGdlMmtvX7gd+Do7FeQp92bxWQEttOH
	Qx9cTu8lprDDh5cmN0cTG6d4wSItD+E=
Date: Sun, 2 Aug 2026 13:08:21 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] CRASH_ZEROIZE: Wipe secrets before kdump
To: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>,
 Baoquan He <baoquan.he@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport
 <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Mimi Zohar <zohar@linux.ibm.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>,
 Coiby Xu <coxu@redhat.com>, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 keyrings@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 Tao Liu <ltao@redhat.com>
References: <20260731154608.153258-1-linux@jaseg.de>
 <am38qk60mpVFuJRi@MiWiFi-R3L-srv>
 <74625f78-15ea-439f-b9f0-939d2976fa7f@jaseg.de>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dave Young <ruirui.yang@linux.dev>
In-Reply-To: <74625f78-15ea-439f-b9f0-939d2976fa7f@jaseg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2814480002
X-Stat-Signature: z5mbmxcdyjryhmanzdbi4euxm7odkez3
X-HE-Tag: 1785647393-899806
X-HE-Meta: U2FsdGVkX1+v5HHbdbW/wkBGBSu9OxWTrxg/VOKIEdNSCjAqy0FcxnoQF+NNvY2LLVMft/HL8cRmDF3YTaMhWxZk+CNXLAyRqS0XZZLbSDqJ0qXh9cHIYf6qWlJUXK1roCd5o5D+R685Eu1+8juPC1KzPMhuU0Uw2fg3vFNP6dyPOsOCmcYVAiVYKDDqdFXeWrjolLQT9dlTjRa945CV3P8jsW98mz12taCmRV6McDEV3oOyTU97qOyC+AsbvscQfHinMSmygq9h0E6Y/sTq593mJmX3HmBzDxoydRfNAn9yfBIs3JgRMXlfdl8JUmJ5ipzIAcvpuynKMEo3MnqmKYcmbyp8kGWp0jcRCffQjnMmz4xemEFMvUhIs7BLtKVsZuQRZ6zNWDBKlCeL2aLSDmZbIuDa48wPWlwQKtxSS1NjaEsCQygz4hti2k2Q8spidwpRmhI3eU1b/oHAf2rrh61lm7fvp+XE/kKN9D4xX2idanMqf88NS6oDbyyttV/QpFqOx42ZBDFyvrCfQ5WwGmI+135MkTMu0cgfTKqWhu+M69CDOkJCvIqW1SimRo4Ep+CBX8u6Ufab4ASugllSzL4/O0jk+9mSW/qnNTbnxIqQjW9UnboSCbJQL5QVs+2/F+FXCaKxfz0zFMfBod5LO4Y/Ra/tqz+SBkJBpooAFuGjxzVERChu3NKmvlsmQZWtynCM5Nvvw/8eP2SxfM/ey2ywXgd6ib8osDmGJE7Lxctrho49Erx9fXIVmgi+4tguHPYmM7KJaQHdAMsk+WucPPLAcGGSF/C4rXjsAU+f7FuGsyrPkveJ8vC2LpKBjW2FemCvWl9HGI6t+fz17VzhnohA+K7gIaaurjkg3uQPM3f/bMC1suIlrPEh9tduIoHWOqCv0F+uPbyXm4hOQ+18TDUbRrj+eExGSpuCksSZbubeKc1dGFjLN6rl3Nj9+ST1/Fb7LS2p0CH9P5qZb7t
 vLeYnLD1
 3Laou40hO6sOQ/C+5rsGKjAJYybpNZ9oFhl44X2EGd10k1Ss65ET/US3BB+nM+CYu4mIvFdZYr4qvVLmmVqBlJASx0qOzZ08ezKQGEsmCEjDTVMD5Jz/nx+I1p2W1gXwSSw5b01RRBUWxqx4hCvm488Nz3X2K8IXVG8Vh4CQ6pQDSuiOvn5T640BDGbPNlDBiOBP6UhzFO7Vsy6kwQkiXTnufe4k4VcjaJSCh1semm0EiWmlT+qYM8rBiCHROwYS+uPPMyJcgEvnBnrmoydEtxIuhqLLTtiQG1tk7WaEOyikmwkSBVHrnwi9D9JtPcmOwM1Zn0TG4GJjEqZ0gH7RhhW82lMFjUboWe77brWs7Dkz8y08GHi5Ynki2iOA2BASN+3Au
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/26 12:31 AM, Jan Sebastian Götte wrote:
> Hi there,
> 
> On 8/1/26 16:03, Baoquan He wrote:
>> On 07/31/26 at 05:46pm, Jan Sebastian Götte wrote:
>>> Add CONFIG_CRASH_ZEROIZE (default off), which when enabled makes various
>>> subsystems handling secret data do a quick, targeted wipe of these
>>> secrets before kdump. This behavior might also be interesting in cases
>>> where you run a normal kdump kernel but you still want to keep things
>>> like fde crypto keys out of these dumps.
>>
>> Please check below patchset, you both seem to have the similar
>> requirement. Please go there to discuss.
>>
>> [RFC PATCH 0/4] panic: a pre kdump notifier list for hypervisor upcalls
> 
> Thank you for the pointer. That's indeed similar, but I think this patchset here makes sense as an independent patchset.
> 
> * The two notifier chains run at different points, and theirs runs inside panic independent of kdump. This one here has to be run after machine_crash_shutdown(), and so makes most sense inside __crash_kexec(). The wipe code in this patchset must be one of the last things to run before the kexec since the wiped data structures could easily lead to problems if something tried using them later.
> 
> * I think this patch series here is a bit cleaner. I don't think this needs a custom notifier implementation.
> 
> * Since there's lots of places that may need wiping after crash, I think it makes sense to have an explicit notifier list for that purpose, and to not mix these with other things like hypercalls. I think ordering is important here: The wiping should be the last thing before the kexec jump. Having it on a generic notifier chain risks that later, other callbacks get added that when interleaved could cause problems.
> 
> * Since a good fraction of users may not care about wiping secrets, I think it should be gated behind an explicit enable setting.
> 
>> Note that we usually dont' want to run a lot of work after panic and
>> before jumping into kdump kernel.
> 
> I understand. For this reason, I think it's best to keep this default-off. As-is, the notifier list call is timed and on the (slow) ARM64 target I'm using, it takes about 3-5 ms to run. I took the "try lock, skip if locked" approach to keep the risk of this code crashing during panic minimal. In my application, the kdump payload is code that then does a full wipe, taking a couple hundred milliseconds.

Not only about the time used, the panicked kernel is not reliable, any more extra logic can make it even not reliable, any pre-kdump extra logic is not a good idea unless it is a must to ensure kdump working.

Cleaning up secret data can be done with makedumpfile + eppic scripts (see the manual of makedumpfile), or it is even possible to do so in kdump kernel with Tao Liu's improvments for makedumpfile previously  (I don't know the status, probably dropped for the time being, but it is possible, cced him).

Thanks
Dave

> 
> Let me know what you think.


