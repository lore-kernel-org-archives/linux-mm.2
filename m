Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE25CCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 02:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49D06B00A4; Sun, 18 Oct 2026 22:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8506B00A7; Sun, 18 Oct 2026 22:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99B666B00AA; Sun, 18 Oct 2026 22:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9636B00A4
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:11:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC7651205FD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:29 +0000 (UTC)
X-FDA: 85337749098.07.4450129
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id F02E920005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f2g7r2Nu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of samarth.colleges@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792375887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eVPJU/fwwlSXblFkJ9qLhkCHM9aSOWirHHGhmta/mS0=;
	b=zNCS0XEKvveYnUeoZLLo7Jj8AERMOtDsPwEcj7mIcNk1QHSTvTeRu2N5sqBPcXcLF4aFWM
	G8H/GqnrWtZ3QfbBO/K1iJH4/Z+Qt1RWPw7ratJj/HcPUetg8TdQ9iMU+4ImtQQcfcqfyR
	2H3+pLeD3EvXMmNEqgF5LB/NoJo/z/w=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=f2g7r2Nu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of samarth.colleges@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=samarth.colleges@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792375887;
	b=pG+tpebL/O4LLcWcGnYDRUOqdTa/zS7sj6aPuMMr1pkB1ybM9pqa/urq4UuuzNg0xWQtD3
	3xpvfN+LoMwzt9mdKfF+XWJjw+MA/ryBn51ZECcJ3p293WgrsxI5u5kwZcRx2j3Ndj44WX
	YRza73VBzVngtMW+WMY2XShb/fQmOqE=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6afa651700eso1902145a12.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 19:11:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792375886; cv=none;
        d=google.com; s=arc-20260327;
        b=kEVR86493uuOPYTRKqWURKGUO+M1WGg+9fQd6/M7SFo3VcQwKYvdlTol/oXnzbKOqF
         NLRM/+c/GKDLOw0vVUYTgKp/hd694uFdja9siAykR1+OBlQ7y3foCD4nuVjcLDdR9OCQ
         w1NUx6+E2CuIKsm6TueJUWwS0woQz9MzC4iX/OJGpIK5mTWioYV4bzabuhnx8w6PU6p/
         Yrm6eXrc0fUOyNKnmrsbByb9ICp1C2/3MY3v0bu67aQlFHA5zeCyIBCN/4FtLr1j4bl/
         yWsMOFs5FnaSL65gbG+kdPVoiiTOBp4BB2RQAYaHWXG4dzaBHtoZ6vxVZD1ya5Krwvoj
         vpgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=eVPJU/fwwlSXblFkJ9qLhkCHM9aSOWirHHGhmta/mS0=;
        fh=orog2g6kOwuv+QoT9nN6+yQ6+hYKRCeQkZYM4//NLCk=;
        b=oKzetN0pWooLK/rbhkLHCJfIkKX/ZrODlvHV5m2x7zQ2mEBqxaOvFfx+xx4y+plklo
         eogWNR26fj/NOzO7Yb3Al8AXrMagLikZx/6P4ND7nQQLPyW32lnt6CK2gkrP9MFGcE41
         4pSfSSQ8WOYoEFK1sBcWHncTus7bOPWGOt7/TKz8ke0ZsZGhacqxyMm4OUph/YW4hcC7
         9w+qg4jMRm5U4k8Ac1W448cdtsTuuRECOrbQnTs3uaA8JIQNL9TbaCTNHadLtmKfukqW
         KR6vXMNCbS5AUIeG0+fbgiFrFupKiKe80K4rqVFLewaTD8MskolZ+wKPb/s0HG6hrSO/
         rCsg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792375886; x=1792980686; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eVPJU/fwwlSXblFkJ9qLhkCHM9aSOWirHHGhmta/mS0=;
        b=f2g7r2Nu9qRwGRN5+I0RyyuBF4OzDgdRpM4/jsLSuySig/haZ+vkbzni0oJ+nfOQQh
         CUfiqv/tbghivexftTqaWU42q5+eWh6gQPdvJnSM3s8ig7iq+S2ALqbw5VHMo7l5gSYJ
         iArh7LYCuyHMDMXAWYpzhE6gKbFFmXWGodkBV/T+7rzMiVEJchLRzkX4BaQZniP4wk0D
         ieH4zartZFJQSmlfeqkbtYjBIHc0WxIFA0R349A5qFVO8QlhcwOly8iLEn1m9LDUJdcT
         Qa7p98KTlhtYR1OwtLFJ3Px+yDInL5hLRcY4WfzF6PC6bblTCP2ibXegHoEpfXDKWv9i
         w0Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792375886; x=1792980686;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=eVPJU/fwwlSXblFkJ9qLhkCHM9aSOWirHHGhmta/mS0=;
        b=oYS0lYmSWa41GnJYDhBpklT6L1D6orHvpD8LgEXaTniVEgognMWl5T3yXk44vSZ3bp
         t8Yd0+Ngeccprws8DS7Dq7Y+sKNq01Js/bAkILFh27sfC/b9kzQ96W4GAQKnMKEgsvcI
         fXFwFiEtXyhVbgp1a3tgfC98VUZs5PWCFkGA3zxc0or+KPTghbc0AJVaJGXlft+7NV78
         2EcdqPomQGqqAY4iHZfW9NxDzyqtsZOxmTckY/MMf/PxMVidBXPHgRTi4BPMmqDFXfp5
         1yi05nf/gjArrVJTjZEZAEV3dPUfVAxVFoKJUwVhoYBnzrqKcteTiT4g4o3mZ38bOKTB
         ko+w==
X-Forwarded-Encrypted: i=1; AKwUvBxeJBNrZbY37pz4/MtLh3t2npyacJSHfCyIXpc+DdGU8LfPdUTmn+nH+B6efWpEjFdE/MGMln1GPw==@kvack.org
X-Gm-Message-State: AFq9FYK/BfqlQ2R4TEA7dwzdwKsHf6CzgiImuFmGeZskdkIiAQTBa5bD
	JS5JEvkf6Re3OV9okyuQSKS9o64WSMM5igoHsFK1mC1qhGTxL77NENacIOl8WJMFK2x2/hOwdU6
	mQxSjeIBc4hsi8SXC5Ct0FvTSNJB4Ww8ckDo6lnEPCSLXaAoJh94ccIMcCjZCCppA67AB3y8=
X-Gm-Gg: AYBFou3Z7AGktjlQFCocxwZh5v2LZp2mrj8tMeJe7R+5bS+cElbZvgujFJo4Ws+oIZP
	Yp0jjXFa2jt4Wf4lCo2BWeIwQxuGvf91xtYHvPNuqRWDE+JTe4ZujXBlchyQXpj0Sq5ZhJfwIYa
	wAX2YufNnGOV1iChOlB3pxcBYzUB92MYMwxwVmIfEVsBnV6I6AtKVrIh2gRfDGImcWVi05b5rlp
	bokvGUHVoULu+WIROsrVTV/D4gr4fuvOjjvOO91dY10zRiEgMVR3Z+lFK6a9SV4iPMVSg1whb78
	kC/Z/oq7ojkl0OVbb/RAWwb8CB6X8WSE3W0W+PNGQ0enBISExhooQ2zDpQpzk+axL1m+HSdXBgS
	/7TsKs6MHuqWybVzJ7OeW77jjI6ky1aZz6PB7WQFKdpZ3eWqIwQ==
X-Received: by 2002:a05:6402:13c9:b0:6b1:c7d9:b61e with SMTP id
 4fb4d7f45d1cf-6b3a81b8626mr3680277a12.22.1792375886501; Sun, 18 Oct 2026
 19:11:26 -0700 (PDT)
MIME-Version: 1.0
References: <20261019010934.697895-1-samarth.colleges@gmail.com> <e2ea8e4f-152a-4695-bc25-1712e385d8a2@linux.dev>
In-Reply-To: <e2ea8e4f-152a-4695-bc25-1712e385d8a2@linux.dev>
From: Samarth Narang <samarth.colleges@gmail.com>
Date: Sun, 18 Oct 2026 22:11:14 -0400
X-Gm-Features: AclHuK-20mnwiOKTgpFE9LGI4FwwzQ_bW2BaCiKbERORT7xCb9t7lskEbWzbR6w
Message-ID: <CAAbz3fSH-JWdyjbyudq0-Zt3FqR+xxLFPM9ELxTO_htXhXKgtw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/ksm: keep soft-dirty and uffd-wp when merging a page
To: Lance Yang <lance.yang@linux.dev>
Cc: Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/alternative; boundary="00000000000004db3b065e28085e"
X-Stat-Signature: 8fm9aw8etjxbrghrqcn38k5rm5wugofy
X-Rspamd-Queue-Id: F02E920005
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792375887-860503
X-HE-Meta: U2FsdGVkX1/LAVeb1e6aM3rAczQMDrc9mgAF0kAe87xRmnWFfkTG/lybAF3yeaWJFuF84ZSBrO0Gu+daRkUebFrVwls/SS9U7gnCCuK+DT6zzTM0zc4COfJXvMha3hVokz+eniBLFZtQ5Xar6xYtdh4WV7lZ4tE2U0WvWb3Bdch0SFCcU9XvzCDdZw3WvvdcfE2oTP+USn6wPXYtH3cnsrTZvzgiaX0Eza/d6glZ0nqbEulKrjcH/TTL4+cuvgKUHLgD64SGyyAMfYeK6Wb299R4k7cvjOQ0Rhq8kQVxzg2GWaklF41bQ2LzYL7DhAlUvE9c84pwVtaheve0BSPMY3FArDAc7RkGFMWLi2Kn/+H04nzdZF0h/Q7pPa8p13TUezZOG2plwkipZh49CYYE7JR4iBHbAM99hjVWEXvy5kRmCKJHjkbDfdD5AleOZU6Yn6uKYnzYkVCvjVdLfNE75tbsqCQ0Uw9Ce52hQScD+/ZdO0OAp9EW7Us/MZK4iGtw0gS0olT9oRTeos9qEiWzhJ3iqhRRSD7bLxi9SzytoPj+oqXsZnFBO0O4iokzyurib46VTwDqRGHFHEqiNCzWn386j4QCupL0yD2bXbYHtTaXKCOAV5x0kAwdM0RcB7Xvhzcz6ZAljEHrloETXN0+WU6Cd1HcnKqeDNI1/TT6ljwqyzAc8pZNR17xrg2HHvmv5pl9X0d9fKIEKpmHwW7B5f07ceUxY3AYimzSEd9kaPlNk6HmvdvDCrc3wMhbX3ceC3Vw91ROe3hDOz7epMO1WeQcFmaMjvRK79n9wzoLMdojY+gtz38v4D8pk1oiwz/j1Yy0ZhEBIMkX8FBTl2OQYFZe8I073wXe4Jg5gjW1Z5iqCyjj/Td0PI+9tLeFkVZnluO2pHbjWM/UVb8CMcDgnvIToS4HfJ7G8JL/BSX5s6nsx2VnHYIXXpIDnVkZUYsNWodFQBCHHIRhLzfcZzD
 lxTIoa0r
 oIq5vJ1gWv5wX97NgGkM3gOVMx3EQoFcYtP6DcJw6KNn6e8AaClP18PS+YfXhW3dQNnunmQB+XF2qH1lT8fdg7oTHPBsXQT2hfx7SUXUDQYD4woQYKXR9YVIlWXjsHa6omdHVhxk4KkK5iJBxehz1jAoOUgnJRpyP1iSIXPWxaKtuPo/kuSPWqjYLGbm1XmwdU/ySPZLePQkPuCX/hzc+LfSGY7PKSsqk5jWA5cSef73E75914LU/YnxbsxF7B7eYjTS3DUeQVPcbo4Aij0Z5I/qP484CKD1qxBunfpUZ6eG/IYpuOZ9/mlBLdESLBWSAudKIB/SYweT2jMiei3eTeQtZZF2bh/WEpF8ZiMY9uv+LHmwpIObWXnL/U8KBhwDBLKqlsNrwtp5w1A6QBaDwfBI3s2j5J4pKbBXHS09mNrlCCykI8RTaC5e5vLfbzF45NX6oj0CI1D//VIfQCb9Ix+zpq3swKW5Mr8zPSTRT21XHIAhft0haHvO0dvUpN+FajY2ndJBtJu8bgpUXlu8WDOjyRKh5yGuTW/K5GiaUJp+w6nSEct1eMi80plPDyz0Y/sYlw+b6Xres4K+n6NHXVY0m6/EtR+YgsavvKx7RbVuWrDrrxIHz/Hq5edCVWIP9jX+YjygL8dcx4RUNFdcLRV/y8gXROllHQY5acTbOfuIcWic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000004db3b065e28085e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=F0=9F=91=8D

Samarth Narang reacted via Gmail
<https://www.google.com/gmail/about/?utm_source=3Dgmail-in-product&utm_medi=
um=3Det&utm_campaign=3Demojireactionemail#app>

--00000000000004db3b065e28085e
Content-Type: text/vnd.google.email-reaction+json; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

{
  "emoji": "=F0=9F=91=8D",
  "version": 1
}
--00000000000004db3b065e28085e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div><p style=3D"font-size:50px;margin-top:0;margin-bottom:0">=F0=9F=91=8D<=
/p><p style=3D"margin-top:10px;margin-bottom:0">Samarth Narang reacted via =
<a href=3D"https://www.google.com/gmail/about/?utm_source=3Dgmail-in-produc=
t&amp;utm_medium=3Det&amp;utm_campaign=3Demojireactionemail#app">Gmail</a><=
/p></div>

--00000000000004db3b065e28085e--

