Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4223CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 12:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F18DA6B002A; Mon, 24 Nov 2025 07:50:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC95D6B002B; Mon, 24 Nov 2025 07:50:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDF816B002C; Mon, 24 Nov 2025 07:50:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CDED16B002A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 07:50:32 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7304688B34
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:50:32 +0000 (UTC)
X-FDA: 84145484304.02.9B73425
Received: from mout.web.de (mout.web.de [212.227.15.3])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4AD731C000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:50:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=HG1Eed+i;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf20.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.3 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763988630; a=rsa-sha256;
	cv=none;
	b=VHSvjfbqROc3wHEPJprMP+fLJ1WzwC8+wM9XWojyhpQdHdvKLdJvnt8YhYMDwG1514zBsZ
	xjranXSvm2gD7RtBlu+gzCE7MOdRGLgB8x8PyZK0oMETiSCi4PxNg0FWlE/qhED05uP7Fv
	j7vyARoV8bbN0mDDxctjnu7wSyT8C6U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=HG1Eed+i;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf20.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.15.3 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763988630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhQgIdmKbTQxoKI+nq85UeEN0e9sut2QP9anR5RMr8E=;
	b=jZgxeQJ3NT3GxBA5KFukVNd/X1UpUL0sUBc07cp1yxy0672CBATqv8pBD6ky/zlZkh6xTs
	Dg3KXbjmHOFPUqzZcbV6Qt/xTeRMeGZmaQkCprSdEczXBuingEHxhVBxGCf03kTlNe+3mE
	vZWwtqGP/f20EA+NBm4bhTZOMP67cs4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1763988628; x=1764593428; i=markus.elfring@web.de;
	bh=FhQgIdmKbTQxoKI+nq85UeEN0e9sut2QP9anR5RMr8E=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=HG1Eed+iGkLo16kbTvJK/fO14URJ29t01j8kdnXmZRixq7u14EbHNThSdodLu/FE
	 s1psod1fZwGk6+TkQwCZVSywKPEPfR89BbR7031Nn6VNs3kYNveT+yX6+lTqiY0VR
	 acAUREN0HFGomC2AdTHSBFsAYET1BaFT5UNYw2ClnBg3QCAVIUmf7w6I0shmXrJ30
	 idvGtjC+tjnyFLZgr8zIb//Rri9hasLKjn5i1+BjUx0C3JAhYVPKV8YRm+UiBcl7N
	 +iDtGfQV0S/HtD/fEDH+m5mENOCoUftXPMSJE7cN35UR9HMN0pdzxKr5O/v7NX4zL
	 j923h8XNCqfejx03ZA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.241]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MLAVa-1vfb8g1ZNi-00Rj9L; Mon, 24
 Nov 2025 13:50:28 +0100
Message-ID: <71d406fb-9fb1-44a9-912a-7a0d270b9577@web.de>
Date: Mon, 24 Nov 2025 13:50:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Kees Cook <kees@kernel.org>, cocci@inria.fr,
 linux-hardening@vger.kernel.org, linux-mm@kvack.org,
 Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
 llvm@lists.linux.dev, Alexander Lobakin <aleksander.lobakin@intel.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Bill Wendling <morbo@google.com>,
 Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Harry Yoo <harry.yoo@oracle.com>, Jakub Kicinski <kuba@kernel.org>,
 Jan Hendrik Farr <kernel@jfarr.cc>, Jann Horn <jannh@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Justin Stitt <justinstitt@google.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Marco Elver <elver@google.com>, Matthew Wilcox <willy@infradead.org>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Pekka Enberg <penberg@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Randy Dunlap <rdunlap@infradead.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Sasha Levin <sashal@kernel.org>,
 Tony Ambardar <tony.ambardar@gmail.com>,
 Vegard Nossum <vegard.nossum@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Yafang Shao <laoar.shao@gmail.com>
References: <20251122014304.3417954-4-kees@kernel.org>
Subject: Re: [cocci] [PATCH v5 4/4] coccinelle: Add kmalloc_objs conversion
 script
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251122014304.3417954-4-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:amsw7UHqOOQu1W5nt8hwneDl1fOvyTGxaKbM/EvmWg36soK67jd
 NVzD/JFRQsE0ej5GzqAq1hrGR1oQ8nlsAf72fRjlHkFo7IftOxVdsV0XQ9BRvbDDGDe7KyK
 i4HOZGwF3BFySJvKFKdQ9UVTYA6ylOHAlIcJ8JNlgNFxheFoVetTSLKXum3Hirf9fGX9OSx
 JNfJAONi4B9Exo5tB2Ihw==
UI-OutboundReport: notjunk:1;M01:P0:gFNAj9rDq0E=;O0N9q9zOXIeNoPvY7WCp5zB7aZw
 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
 R7dzVIYFj5JrZ0+My9hvasRPbIDNUTdNye/8iK
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4AD731C000D
X-Stat-Signature: q9apxuqbb6t49i37s15phpk5jgsejdxh
X-HE-Tag: 1763988630-149672
X-HE-Meta: U2FsdGVkX18iTRiOiJOj7ncnnl1FPpARlkG0bCSxW7UIjrL5iMy6/L/tath5peVPGlCkDkBt8DmcKMY8lHQkhS+3mNm7v+mCTVlldsPjKAoI1Sr2uJZ5viHRtwKIJhP6OZf/pb4GnvYznDbMxtR73AAhnd05QKCpudFfzgPxjVVFhsOg3y57LRU40UJMMYdtytu7kkuuTjmaTRomh5ogTErrv+5vZMWRKahv52rLTH+KGdtRxTQ4SMTDF9c1Lrqztc8uRbxVk2Yy8ZwkTtkGrgCb8pKW+hAxmWxUVxbBdT8QVeYHfoe79cH9JwEGRUvuXA3fg9VqBZU4vJpYNAZiJYceoIyN2Iiwm6o7nlgbaGF/DwkrM08g9yis4ih/8aPSkzzSyiO5baBZoDhkCD/nKyDqa7leVUlrQVfoUpDy8R7wvTbEF/ug0jjp9F5Sp2ebAeAk29Cpsqo3iUmhSd8OUpSqih5aAP3Ht7sZmNrKHLwuKC1vSOZZHVmOCB0rlosXYD9PjWYVHIWYiand1GBSv6Lt58UAg+ZE/EKqrL1rHqhI7F845uUfUckFdAcm74SrgiSUMG1i8Ck8bHY+5IRG4m5OLpX11g6pW9YNY1/SrCttbtAu//NCHmNiEOGV8T/2rlk4EJUjk+Rlmqc8ObWEX1sULoPIKxl1KfXBfQTzaoZ3soMLk3YuhmANoEAzjRFGP08qRZDQRuJ7rXCR2Jp9ZGAVyWUFskt7R3C3CmV0IGlbtOdokGE/NE/C/wlAFOYbhGsete8FwTc9MLjxj3/t+3v6CYZad54Z1jsFtt4nHKwSzIboKYLsQgsBidhTzeK+bejS8fIkxk1j3oedJLr08dZeiYY+bLzPsZzW3zc04MYm/xOyjBOE45fHVFszKnROtpw5SEyg6vTcywnFexEtNJVNxoYr5LVrLSemp07uGzGHFkm1/Ie4jRjhWanSJKNDEF30mzlvq0DlTBjeHhq
 YL6hvY07
 sFPiO9Oo3dJxYYe/l7sjarksEcYMZGDHzJkXLvwnJDRZ/aJq/sU1Yg72w+LVYzz1gFCKATXav+5Scfi9GUY7lO5nZkXGUWd1ZXuXw3yyrZlWv7dRIwQtuXSIZo+CgbwCBV25DsmNn5sa/dfo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Finds and converts sized kmalloc-family of allocations into the
> typed kmalloc_obj-family of allocations.

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.18-rc7#n94


=E2=80=A6
> +++ b/scripts/coccinelle/api/kmalloc_objs.cocci
> @@ -0,0 +1,168 @@
=E2=80=A6
> +// Comments:
=E2=80=A6

* Please omit such an empty information line.

* Would a field like =E2=80=9CKeywords=E2=80=9D become helpful?


> +virtual patch

Will additional operation modes become relevant after clarification of imp=
lementation details?


=E2=80=A6
> +def alloc_array(name):
> +	func =3D "FAILED_RENAME"
> +	if name =3D=3D "kmalloc_array":
> +		func =3D "kmalloc_objs"
=E2=80=A6

* I suggest to avoid duplicate variable assignments.

* How do you think about to collaborate with the Python data structure =E2=
=80=9Cdictionary=E2=80=9D?


=E2=80=A6
> +type TYPE;
> +TYPE *P;
> +TYPE INST;
> +expression VAR;
> +expression GFP;
=E2=80=A6

Such repetition of SmPL key words can eventually be also avoided.

Regards,
Markus



