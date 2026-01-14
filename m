Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6046D3901B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 20:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368646B0005; Wed, 14 Jan 2026 15:44:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3294B6B0089; Wed, 14 Jan 2026 15:44:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252BB6B008A; Wed, 14 Jan 2026 15:44:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1435D6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 15:44:07 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CA1A59112
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:44:06 +0000 (UTC)
X-FDA: 84331746492.11.39AD85E
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf07.hostedemail.com (Postfix) with ESMTP id 985154000B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 20:44:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=eIt1oh6C;
	spf=pass (imf07.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768423445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woowc8iyRdlq7O6uDbNaE+SJXZ6TMqKXI61xMqfH4l8=;
	b=1NRYPXmoYKgobYMi+M3x46Qbtjsbj6GjFZ5olkD9hIXtrlZgBfqoiuqCFDH+UwmcBgPQbQ
	49hQZj7cux5n9CX40hgPgRfqfkq837hL83jVIyN1PZt/HcVOHh6YtrF0jCcXdgHutTDXz6
	1wDTDRcrjwxksN/uTPOP8cbXAIKidpM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=eIt1oh6C;
	spf=pass (imf07.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768423445; a=rsa-sha256;
	cv=none;
	b=xELSCRuuENNfc78YQEUBOTxEbKzoAJPRYIUB780rAb24Rb4QXm0Jq3HHw9jE8MXp0iE8Nd
	V0prgDuH/7ylsNzmVZ01y3WVPl4MRnXRf9qs4zdSRYuCQxWG5qYNTortx9B4R7zbnYqtOC
	ztkceqnJkJOlw9Dj6CmsPfW3UsWvtAs=
Received: from macsyma.thunk.org ([136.144.33.86])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 60EKhrPJ027987
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 15:43:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1768423437; bh=woowc8iyRdlq7O6uDbNaE+SJXZ6TMqKXI61xMqfH4l8=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=eIt1oh6CTSbuCFH2Aa+tDH5O6d7ert5PTo8L5MznoWdJurx3wVcQGHbhxt3hVCKcD
	 fFpIQ8m+pnK2HwS059mGDkfqX+o3C8AJW7v93iyuuo2dSOiGgRUYbY3SfnlnyaODTR
	 RYBYCQBUrYJQsD06OcVW16PXm29QNwcAGIQUHQaglDA1x2h3C8xbkDIFEyffk/WzNW
	 Kx7qS2POn7rXcDqdy6YcTblw6ezhNTnfQNYdu3eTX/h/AGowNy4BwrBE9NO/IDzhfC
	 2lHVZGFLCbjTpIMAGWgxQVAYcICyVi3DFs70U/R2N7jBTSBfocy/Jp8qRNFWZXkZHl
	 e2VOx4tr/gA+Q==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id C1B6654AF834; Wed, 14 Jan 2026 12:43:52 -0800 (PST)
Date: Wed, 14 Jan 2026 12:43:52 -0800
From: "Theodore Tso" <tytso@mit.edu>
To: Nathan Royce <nroycea+kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: TmpFs Incorporation Of FsCrypt?
Message-ID: <20260114204352.GA19200@macsyma.local>
References: <CALaQ_ho-dx9CTee_-R1VFreX=jB3Zbdjo68fdnnwC1cPoPcjVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALaQ_ho-dx9CTee_-R1VFreX=jB3Zbdjo68fdnnwC1cPoPcjVg@mail.gmail.com>
X-Rspamd-Queue-Id: 985154000B
X-Stat-Signature: u6c3ixtfkfmm781r7xuocrfzaw8r4rjd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768423444-270048
X-HE-Meta: U2FsdGVkX18LAo3RAVbAWIB83GOav7lZTaAR7jx9BgeNs0kM00z0A/Xsy/uDwg9omsoPl+CMXUAJH+7R9T30j+ha75LyV5oRyo4as7sm4u51ffHRyvI64D3KQzpG1LCahY3lnryzwmOkrkYjZ/JARkpETJb4pMac4ZUzzN5PvxFdi+E0wABb/APsMdckNtl+MSXA1L0s30UlFoj0XBXvFPe63pPaV7+NSIS6Qun1dY5fFU2po7A8PdKVbJMYx5iw9Wvf7DvAlTmQ4JcqP3RW6Q03W/NfSc/MPf2luzqFHEH+UhlJxnL01AG78UUs7nTQCm/ApN40asM9Rov288k24WzkmE9BSCDGW86s92W9F7u0t7USdaEzxQUvCPmPpEwFcd6cZSZFOQR5dr/zp4lkKD2GDJKUTO1vkiohKSwF1hbtLTaEZlmjRZHrHPTOm5b90yWa5fY7Exa+HkJVu4NV7+xQLEX3exRAV0kTfVHIb5Ha9mDQ+TlPJd1JOaTmS2bkZxjQubX5q1dBTUNKamj51YrL8Ui7LPYb+TiCG9q7nIFMJ1LrxrJqrt4JNVk4CnehyEY+eCWlo6YXPdsJXw3/mRHFULdgYGp2i2umUtIUMMJLxaKnSpdQDtSd69YnvQoCvFO+/t5RXCaIypGZZ8mPxWMYi1bnm1e+B0lk1vAf2o25dFWiO+fwPag/b4IYrdW1CJTue2htjQ9u0eyB0GKImEsf4SdGc+jefa8eO4xYdgIPZWZpO3jc5nslD3NxawfompvV66Rq55yuapFeRlLnACD0Coxnm3L3r38Uc3uqF92StAgsNp80HjB7wI2KB8ClUhgv7PwnmHGiz/wXXZoUeEQOnz87mGpFPwsOTPl2f2/nNev9MageVXnLw6Q19ITxD+y0Sqj+BLFAsOWntGk7iwUMgVfzbNM+44POUc3fiFTpMApW7NLcL4FlTIQZVNocnxIJnn4POTKee2RoL/A
 MG/orwUe
 GLVvRfPOl8UCeCp81PmKlpIWNPzTCY0Fj4w2KEg1qsM50dclNpYnE2DvRUBJuFoR/fdUXaoLsNMJX/AV1GQZy0BGpB1ahieNMtUYkNyvp+KuVFsnWpm6nB2BAG5EKsSk+7oWWJP415kjEN+lisHklU89pQ3aH1D5OLiMqoNg9yri8NA8VqgsYb6S0d/B4UI+eu91z2c3Jwsc//q3pytWCbPHX2m4qjCFep2kK05YDKEU/rg1iT+70xDE2j02ewghQlS+g7npbk0SsG6JyKAfCYZEUqCsLe3bcDJ488M1dTIyGimY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000009, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 01:03:20AM -0600, Nathan Royce wrote:
> But I also saw: `The source files are located on an in-memory filesystem
> such as tmpfs.` in the main README, which makes me wonder if there is
> intent/plan to bring fscrypt to tmpfs.
> 
> I'm kind of thinking a use case of having keys and/or a password manager
> database on external/encrypted storage, that gets transferred to some
> random path in `/run/user/<#>` (tmpfs) on login where it is encrypted as
> well (then the storage is unmounted/locked/removed), and the respective
> program that uses the file(s) would point to a freshly generated config
> that points to the random location.

I'm not aware of anyone considering adding fscrypt to tmpfs.  One
reason why it might not make sense is that the primary value that
fscrypt add is encryption at rest.  For example, if you are using
fscrypt to protect user files on a mobile phone, the file system level
encryption protects the data from being accessible immediately after
the phone is rebooted or power cycled.  Many of the attacks which
require direct access to the flash storage, or attempts to replace the
kernel with one special "enhancements" courtesy of the NSA, KGB,
Mossad, or MSS.

However, if there is a zero day vulnerability which allows the
attacker to compromise the currently running kernel without requiring
a reboot, and while the encryption keys are in memory because the user
is logged in --- fscrypt will likely not provide much protection.
That's because if the keys are loaded, and the decrypted file contents
are in the page cache, the only thing that prevents the attacker from
gaining access to the file contents is the Unix permissions, and the
system's discretionary access controls are very likely going to be
compromised if the kernel has been compromised.

This is why fscrypt for tmpfs might not be that useful.  Tmpfs is not
applicable for storage at rest.  So when you copy the encrypted files
from the persistent storage to the tmpfs, if you use fscrypt with
tmpfs, the only way it would add value is if you want to remove the
encryption keys from memory, without actually deleting the files from
tmpfs.  Otherwise, why not just zero the files and deleting the files
from tmpfs, and when the user logs back in, just copy the files from
the persistent storage into tmpfs?

Cheers,

					- Ted


