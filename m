Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 401D3CA1017
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 01:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5328E0007; Sun,  7 Sep 2025 21:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C748E0001; Sun,  7 Sep 2025 21:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B1E8E0007; Sun,  7 Sep 2025 21:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7458E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 21:09:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2969BBEF5
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 01:09:56 +0000 (UTC)
X-FDA: 83864301192.23.0E2AAA6
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id C9CCE1C0005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 01:09:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BHpdb0cj;
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757293794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VAz+B+mOkMm8Do7qT5j52EhZhmc+v/y9ZYB3bwOj5m4=;
	b=D9U8RElLUpfrHKCTnQwtdszZHwvJK3WlT43ekckpVBqFhG0xq07UDNGo46FiyT1A8Xx0tx
	kDoZCQHN80eqaDWlpZXx+1QC9OptCSx7e4OIDGVzk5pJubyPYICUBDPgnuQeWj+JX8pvC9
	5oWb9tZ44t/TVRrtVwiW7fGSlKmnNXU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757293794; a=rsa-sha256;
	cv=none;
	b=VlxIGAC+MZELUIdqdmROfaLJGCQgn/OxrRY6VWRHIupq0c7mEzO5xAhYzuDlcHGvYv4ObA
	Cjan3JTEnci2orSujG9BSn1Vso8Fu7e/MUA2BJc9P2NuEMMiqe2ODwM6SlHtc07AfTWfow
	bkEKYT6T2GES22b1EI2SLZy7QOUVMpQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BHpdb0cj;
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7725de6b57dso4478176b3a.0
        for <linux-mm@kvack.org>; Sun, 07 Sep 2025 18:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757293794; x=1757898594; darn=kvack.org;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=VAz+B+mOkMm8Do7qT5j52EhZhmc+v/y9ZYB3bwOj5m4=;
        b=BHpdb0cj4yFLC8d13WqdDnkmcb5QqLS7n8JA5g145iEUyRX2Rpc59YOuHYcdDUQBNw
         h/lWAsxS6jUmmZuZ0d/uCYTseF/wFsQZ134XT/s10hywNJfAXz5BWFjTnlee8qOC49VO
         4MOY/upIYbi+f2JmXTQgNIhAqI5AcrqXh/ngksuseLmyoOdzFFOylDd6wpFAhbnrbyPw
         +oG+eXSvrchA6ELdGd06oYq4tOeTiZ23lHLfQra5DylrbIDY05CowUdaEuaPAKx5TzGC
         9nwI47etuV0LI9/L1Kyq/iFtif9YrUdKvJqMN0wTrJrTTgXhip6mOmN0bzdUC5khZ5Xv
         UxcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757293794; x=1757898594;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VAz+B+mOkMm8Do7qT5j52EhZhmc+v/y9ZYB3bwOj5m4=;
        b=ihrKeS6dOshty/wPvl+8wz4zXiTyMVv0gFTU7tZ99D+hHJP+mVp2SJPjSkMk11v1c1
         I1HnvAOx2qYHLhXUdEBuF2WiZyiEKSBJ8QLyylHmK+iuzSuKDBBzW/sB6S27B5JCtpMi
         /rU73Moh8RLegiBya49cTDAFSYG3TVQON2RuPMk5bOeCgya50MvaelWK8PjsbvVICQlM
         Any7x25jWu0phPOQIC2e1cl78rarcLH8T+gd7Lon97/k9hm5cdgfv05XqsiucSTaGOpZ
         dx7VJDDkTD8V30Pj1uwKC/pjkzeJRwJ2X0ZmlKden3z+Iq3/QakMgXDVOkrURs2YhEqN
         mPUA==
X-Forwarded-Encrypted: i=1; AJvYcCXYzGDGRwjwGLnea194qBpBttvknrV19DBGARLN/6e2g1E1xrvv4xP0/cdOGNLSDaG5COSvlkjg5A==@kvack.org
X-Gm-Message-State: AOJu0Ywk6hluccIR7JFZzy48JJ8KHq0B9yJrVEfEPwUZ0Mpjqb293Lxp
	SBhu7Cn4uX6Ym9f+J3/XrSCsiiVtDOFS7ZloPXuLEiamVNEB0r/e0EZ/
X-Gm-Gg: ASbGncsa6Vrg0YpwVKWV/IDPzGxj17gWR4aiqSQbV33VBDklH2XAXgRTcZj56dOdIKH
	ariMD2QOqUo2tT3fthte29bMTRAVjFddL+iyVKKULhaDg+a6neu3upWSJwrmmXuj+La+pifWlY9
	/t4sdkW1H67DxMar9AwpZZ/vBumUVgsH78Id+/wfJVpBb1A2S0LHSUnloMa9cdn6sXlwAlAktKq
	gpcis37IP6AyqTtJNNjBojU0DWvhk4KX87axPsTOVDKKi/GYq6THWqlk/J6dxG+rfHGZhWSDW8I
	4wEyB9l4q0tvq+E02oLsDqZ0QWWvtMFfcIDh6pyNWS133VY3AwefRF0CPOfj9VowbBzVORNqQtS
	mPrp2GGK8NHuu4SkJZTdV
X-Google-Smtp-Source: AGHT+IEyAGBKDmt/fIerkx6WNxaQOMnvOULD42MdqjtAjFxVo1bnHJVQLeBW7q2Q4Rji9ObS/3Sdfg==
X-Received: by 2002:a05:6a00:2d1d:b0:772:44e8:ce65 with SMTP id d2e1a72fcca58-7742df243damr9065362b3a.32.1757293793487;
        Sun, 07 Sep 2025 18:09:53 -0700 (PDT)
Received: from smtpclient.apple ([2407:3640:2276:6693::1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4e27d1sm27590434b3a.81.2025.09.07.18.09.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Sep 2025 18:09:53 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
Message-Id: <68DCB9F1-9BAB-44B0-826F-63F1708895D3@gmail.com>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_2E9CF73C-BE96-4286-9458-05A853970B80"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] tools/mm: Add madvise tool
Date: Mon, 8 Sep 2025 09:09:36 +0800
In-Reply-To: <kve7xndhm4hzaglmzrpjiw22ut3yvcyb44n3oxx7cayiglhzh7@wwpgldcgl2p3>
Cc: Liam.Howlett@oracle.com,
 akpm@linux-foundation.org,
 david@redhat.com,
 linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com,
 mhocko@suse.com,
 rppt@kernel.org,
 surenb@google.com,
 usamaarif642@gmail.com,
 vbabka@suse.cz
To: Kiryl Shutsemau <kirill@shutemov.name>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <20250905032613.76910-1-lianux.mm@gmail.com>
 <kve7xndhm4hzaglmzrpjiw22ut3yvcyb44n3oxx7cayiglhzh7@wwpgldcgl2p3>
X-Mailer: Apple Mail (2.3826.700.81)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C9CCE1C0005
X-Stat-Signature: 4yzhbfz768k81i1c8rjand5on7nsj34m
X-HE-Tag: 1757293794-536888
X-HE-Meta: U2FsdGVkX1/JzldV0Ux8AIvde8kHubEjrQdlcbW0K5wY8gkPHeqH8CCetx4xsXAdlecjwBk8I6CCUHvJ4jETwSt638CMUFYRjZ+OylmFAnr+dQglCvJDEyHk7y416hpKcISVmjvXkYuBvLNRHbqceFYR5aWUTsyyXJsWW390XzGS6+HR9C3nJj6cCFu7sG3jWNZViFHs+BT5i9fAn8BMbqBKnNSp0iP4mXsj9nSB33b4aD8exUVb8gR0KwEPqNW8zEyb1rRVzMD+OzG84L46V9f8kYkUa6IzPk6ZVbO+tgKk10OJHupUkO+xXSfIILUFsszJKm1vwM/kizOsTVFusaCRlYaxhsCjRz2vQLTMCPspB9NeBIh/xEWw+MOeVU2lfyrhFCMznE3af1t7Eu2OIDG45n48JN1wgKqLKGVgI42KiZcoVmr4fsMX7PUS+joVd1uPX1P6dumVDXWX+dFGHRd55NZiKZEdEOYCvsayE7I8UaEMvbLEUootl9Hy3u1BjAV6nRZW3KygnsVnLa/+24puieeHxJN07WjvD2PBZSRZRHRqLWLo81SeyA2BsLx8BZ+9+wKLY1j/ZpEM0ipGdXl21TaazsKSuSBlQA6dOUs5uXb7DVp3dWvzjZPFNmCFv98txyoM0F9RpY3FvEUYP7xp8y1sN30h3/eL67eFs16/j17pzKg5NnLL/OLANMvKteC7ttn6xQ0aAIZWMWh+TfzD5pXhra1A12sMnxCqiFrN1gwZFDImd+V8IJwuehOapZHUql9WVVuTzMdbYxofBg/+SCWUvH7Gfp62U+gCA/VJumhPZyYTdO2vI+cvfVcvawluz9+uHGO4upRsecgJVnjziFrz+u8wHz+qvx0fcMztC145wwBBznNUQTnCgmdaVhLvhEHLNqxuIjEkJruNPTJfcQnZ+pFrepPdn7vVPPsVXzW7IrILMIiyHEMIck40VPLHiuEhMl/MebPRFvy
 j1dSRJ4n
 qLO3O8p7KpqtTCs6BCJSpXkAcm+pxXQ9S7rr/4HPbT/buuT+qZHnXCqsdOG+xVD4NDyVqZmKilf//6+npwJy9JNS68rGJlRFblUKxO6zUHAZD/l0xTY3LuXYidF9zEwy8GxKnm/AxnZeJUvf6kQsVqL/yBO3gcthyjJiSQ9ZG7Lr5fqhHk7azMpJXv1FEzMIkExdL3rl5mNTl6FwuG1VnPjseeYcJeFnmh2I/Bf/4qy5UNfRerpBwzPgsClRH4fRLQt6kNXPSn2o5HAUpDOSU5e64l1paysTsAuvTzzz6FhqSdE3VSk5qyjKwisBKFF2J4J8xfQgA1On40BFOlKvzZmhkZVstLjcSt1OE8LwaAjbZa7XrO3q/oTvzr8yKEyAeJwFxlVurQhEaGc0AbdwUkgAHg7/nzaeSLhayaHA812ASKNJur4h5rVT9hy0CyfuKqSFjTQ0gYt1EBSvpW5YK7OSKZmkyaN/m8H3Fb1Kd218b4zOyu6+0vw36iKMDXqNBBc6JdKEvQyS9hix9dRjcxbS7Ec6F5WxxAuH1UpCazhknppNAVvYrxUMp2Lif+1KKkHN42XC8PsulVi0mxyBE6/Xy3Xy9G7vTbIEcYgJCKb4LdCDVu3ywOD4fqVPFVrzdchFQ/L9ycwbcB13zlu8eTS2X+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Apple-Mail=_2E9CF73C-BE96-4286-9458-05A853970B80
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On Sep 5, 2025, at 18:28, Kiryl Shutsemau <kirill@shutemov.name> =
wrote:
>=20
> On Fri, Sep 05, 2025 at 11:26:13AM +0800, wang lian wrote:
>>=20
>>> Add a simple tool that allows to issue an advice on a process or a =
file.
>>=20
>>> It can be useful to experiment with effects of an advice on a =
workload
>>> without modifying the workload itself.
>>=20
>>> Only supports advices available for process_madvise().
>>=20
>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>> ---
>>=20
>> ...
>>> +#define PMD_SIZE_FILE_PATH =
"/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
>>=20
>> Hi Kiryl,
>>=20
>> Thanks for this patch, this is a very nice and useful tool.
>>=20
>> I just have some super minor nitpick on coding style:
>> (a) Maybe move the #define PMD_SIZE_FILE_PATH to the top of the file,=20=

>> right after the #include statements?
>=20
> Maybe. Will do if v2 is required.
>=20
>> (b) use consistent comment style like this /* */=20
>=20
> See answer to David.
>=20
>> (c) when i test, when process_madvise test fail it give some message,
>> i think it should add into in the prompt message ,like this=20
>>> printf("madvise TARGET ADVICE START END\n\n");
>> printf("should run as root\n\n");
>> printf("\t\tStart and end addressed for the advice. Must be =
page-aligned and valid target pid address.\n\n");
>=20
> It doesn't need root. If your target is PID, it requires the target
> process to be ptraceable for you. Whether it is or not depending on =
your
> setup.

Thanks for your clarify.
>=20
>> Other than that, the patch looks great to me.
>> LGTM!
>> Reviewed-by: wang lian <lianux.mm@gmail.com =
<mailto:lianux.mm@gmail.com>>
>> Tested-by: wang lian <lianux.mm@gmail.com =
<mailto:lianux.mm@gmail.com>>
>>=20
>> Best regards,
>> wang lian
>=20
> --=20
>  Kiryl Shutsemau / Kirill A. Shutemov


--Apple-Mail=_2E9CF73C-BE96-4286-9458-05A853970B80
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"content-type" content=3D"text/html; =
charset=3Dus-ascii"></head><body style=3D"overflow-wrap: break-word; =
-webkit-nbsp-mode: space; line-break: after-white-space;"><br =
id=3D"lineBreakAtBeginningOfMessage"><div><br><blockquote =
type=3D"cite"><div>On Sep 5, 2025, at 18:28, Kiryl Shutsemau =
&lt;kirill@shutemov.name&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div><meta charset=3D"UTF-8"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">On Fri, Sep 05, 2025 at 11:26:13AM +0800, =
wang lian wrote:</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><blockquote type=3D"cite" style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><br><blockquote type=3D"cite">Add a simple tool =
that allows to issue an advice on a process or a =
file.<br></blockquote><br><blockquote type=3D"cite">It can be useful to =
experiment with effects of an advice on a workload<br>without modifying =
the workload itself.<br></blockquote><br><blockquote type=3D"cite">Only =
supports advices available for =
process_madvise().<br></blockquote><br><blockquote =
type=3D"cite">Signed-off-by: Kiryl Shutsemau =
&lt;kas@kernel.org&gt;<br>---<br></blockquote><br>...<br><blockquote =
type=3D"cite">+#define PMD_SIZE_FILE_PATH =
"/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"<br></blockquote><br>H=
i Kiryl,<br><br>Thanks for this patch, this is a very nice and useful =
tool.<br><br>I just have some super minor nitpick on coding =
style:<br>(a) Maybe move the #define PMD_SIZE_FILE_PATH to the top of =
the file,<span class=3D"Apple-converted-space">&nbsp;</span><br>right =
after the #include statements?<br></blockquote><br style=3D"caret-color: =
rgb(0, 0, 0); font-family: Helvetica; font-size: 12px; font-style: =
normal; font-variant-caps: normal; font-weight: 400; letter-spacing: =
normal; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;">Maybe. =
Will do if v2 is required.</span><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><br style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><blockquote type=3D"cite" style=3D"font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; orphans: auto; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">(b) use consistent comment style like this /* =
*/<span class=3D"Apple-converted-space">&nbsp;</span><br></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">See answer to David.</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><blockquote =
type=3D"cite" style=3D"font-family: Helvetica; font-size: 12px; =
font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; orphans: auto; text-align: start; text-indent: =
0px; text-transform: none; white-space: normal; widows: auto; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;">(c) when i test, when process_madvise test fail it give some =
message,<br>i think it should add into in the prompt message ,like =
this<span class=3D"Apple-converted-space">&nbsp;</span><br><blockquote =
type=3D"cite">printf("madvise TARGET ADVICE START =
END\n\n");<br></blockquote>printf("should run as =
root\n\n");<br>printf("\t\tStart and end addressed for the advice. Must =
be page-aligned and valid target pid address.\n\n");<br></blockquote><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">It doesn't need root. If your target is =
PID, it requires the target</span><br style=3D"caret-color: rgb(0, 0, =
0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;">process =
to be ptraceable for you. Whether it is or not depending on =
your</span><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;"><span style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none; float: none; display: inline !important;">setup.</span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: =
none;"></div></blockquote><br>Thanks for your clarify.<br><blockquote =
type=3D"cite"><div><br style=3D"caret-color: rgb(0, 0, 0); font-family: =
Helvetica; font-size: 12px; font-style: normal; font-variant-caps: =
normal; font-weight: 400; letter-spacing: normal; text-align: start; =
text-indent: 0px; text-transform: none; white-space: normal; =
word-spacing: 0px; -webkit-text-stroke-width: 0px; text-decoration: =
none;"><blockquote type=3D"cite" style=3D"font-family: Helvetica; =
font-size: 12px; font-style: normal; font-variant-caps: normal; =
font-weight: 400; letter-spacing: normal; orphans: auto; text-align: =
start; text-indent: 0px; text-transform: none; white-space: normal; =
widows: auto; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;">Other than that, the patch looks great to =
me.<br>LGTM!<br>Reviewed-by: wang lian &lt;<a =
href=3D"mailto:lianux.mm@gmail.com">lianux.mm@gmail.com</a>&gt;<br>Tested-=
by: wang lian &lt;<a =
href=3D"mailto:lianux.mm@gmail.com">lianux.mm@gmail.com</a>&gt;<br><br>Bes=
t regards,<br>wang lian<br></blockquote><br style=3D"caret-color: rgb(0, =
0, 0); font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none;"><span style=3D"caret-color: rgb(0, 0, 0); =
font-family: Helvetica; font-size: 12px; font-style: normal; =
font-variant-caps: normal; font-weight: 400; letter-spacing: normal; =
text-align: start; text-indent: 0px; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; =
text-decoration: none; float: none; display: inline !important;">--<span =
class=3D"Apple-converted-space">&nbsp;</span></span><br =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none;"><span =
style=3D"caret-color: rgb(0, 0, 0); font-family: Helvetica; font-size: =
12px; font-style: normal; font-variant-caps: normal; font-weight: 400; =
letter-spacing: normal; text-align: start; text-indent: 0px; =
text-transform: none; white-space: normal; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; text-decoration: none; float: none; =
display: inline !important;">&nbsp;Kiryl Shutsemau / Kirill A. =
Shutemov</span></div></blockquote></div><br></body></html>=

--Apple-Mail=_2E9CF73C-BE96-4286-9458-05A853970B80--

