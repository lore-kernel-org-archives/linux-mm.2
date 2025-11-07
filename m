Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 867E1CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 12:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39538E0011; Fri,  7 Nov 2025 07:03:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E107A8E0002; Fri,  7 Nov 2025 07:03:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4DE88E0011; Fri,  7 Nov 2025 07:03:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C559E8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:03:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F1461A047F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:03:32 +0000 (UTC)
X-FDA: 84083676264.18.0506090
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9DA328001B
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:03:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TfbkxWN5;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762517010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0SUZOwa2DoxMDRc3rqTByEvMDEEitrrZ2mKWUz1yRw=;
	b=nfg8IwJZK5hc5PXoOVl1LD+BRUgtviO+uEUmkqth9oAEoBveIDhSsO55vGwbbXSeutjV5t
	zWcHAbN1THaisntsREeyRlqvqa3tNxp1IlKKI0jWEhRj/jse0snNHTDYjxD4PazYX1Y0uc
	ECLELpE8Sj4Wr7TsjgnXrQOxQolrtn0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762517010; a=rsa-sha256;
	cv=none;
	b=SjlGZLczgk6prJV/jaRwrxr6SKjXKLQzFVhjQeeS64yLmhUz+eEOeOdbb2YvOH+sX9NZTm
	Lc96tWyFgcl1fLf5ofE11OJM9Agn834xkeesmeoS0Ja9oFUEeYr5zkgb6nC6Q8Hzwp5JDh
	2tJ1mhQ5o2BMZVfTX+9doAZWPD2jyp8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TfbkxWN5;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b727f330dd2so103149566b.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 04:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762517009; x=1763121809; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0SUZOwa2DoxMDRc3rqTByEvMDEEitrrZ2mKWUz1yRw=;
        b=TfbkxWN54y1jvlRpBxx4CH8sxBwNKv/OUld/6cOHk4VDvCIun/9LE01ZHFo2QyENhK
         Nj7PlxFlk+5tYJkhttHOGrxWE1Ey8QBEOwIkN6qXkRUyaVUYGucdKrk6dMDw9IKswVPk
         5/mRKTzI8LjjnkvVE8KK3uFYZ6dBw3CjcZOSL4dBwsDNLc+cBUimCyQtXq//zlEfHCaJ
         LLQnqVNhshgxDg51XlPCtbTeER6Qz9B4LaioDOKsGxBtKmnVCxf5q13mDM9jtmRV9SPM
         A6DyrplxQ5pyP0jNif9cT8+DmWJOy8+r1h+DFqak159zkaRVYOWBkVJUvZIYo/do4T6b
         VXJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762517009; x=1763121809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C0SUZOwa2DoxMDRc3rqTByEvMDEEitrrZ2mKWUz1yRw=;
        b=KsWDajkKvauCKveoDEl74DDCHUlW+QjmpMRuJato4+zgYPEnBEA6VvQMLnxEk86rD7
         QpEPTDs62hzeHUUhPiPI8p3LO4vaGL1fWeySabV9kcZRznLvNxcJJASi0hTPIj7C6LLM
         AqF3mbCmHgG5Hpf+e8J4HEJT47Xy1t0X0nUP272gHtELnyT1016/2pJfdG4GgT3k0JTU
         nTIS8S5KLiz640o0UqgTb9IlhT7cEsEHRZ3PgfkRRsljAZ/k/hRK0ldCY5rGZj7TpaS1
         3BH3a1qD/ssbX7ovKekqf9/GDQns/7hRrG91sfIf6P8NjBhXCa/yeLAm1BZHivzh5ygI
         4fyA==
X-Forwarded-Encrypted: i=1; AJvYcCX7E0LqYpzDFvya155dRZEXE5ou0PwL5dXdqpJSddC1NTn7PbNKT6sAYic7jyyLYSr6aHG0Ih1v/Q==@kvack.org
X-Gm-Message-State: AOJu0YzFVmfzeYBOsz/tzFgUBv/YzAqRFRK/lShjJmlBYzQmfAIPYLCx
	YmqSLPf08wx0akMsRU3QXNbV00qWANdEhULA5BTyYW7OHZyZ6RxD9VxQ7u8RPtiGoFc/fdmvaRz
	KDA5l0ldF+TPDJUlg+MZjuUE+Y22f17t7AilDM+q/4A==
X-Gm-Gg: ASbGncsLt9jfE6gmwX/t1tyRhBS12ra+gvqnRY+7Y1aYZ5a6jpFDHhB1XGo/j/qoaSv
	+wEVO4RokvQnvpQ/VoAywJ2NDOhBSxc+EU8XWxSxOACUiPA1zPgZhgDw5JvWMlO1Ul5H2ysi2xs
	RD1Bt3IOpJzmqnOetLSwVHt0AOf/oNftb9n9CeA63TTDVbH+fgBvjxJ0mO/QMeEnB7DsWN2P9MY
	HEfgVPR4Si0KviuQLkQHQoVhKCUbrRRdARti2T0Y8pI/812EFVseJ4H8Wbq990Xh7JG
X-Google-Smtp-Source: AGHT+IFqhmWJ0cizgg2FabCJ2Y+psCwYYmTaIqkaXVpc8XQgBzLaJv45nRBMIXurahATrE3jLrd63/YppCZUaEvDwmI=
X-Received: by 2002:a17:907:1c0a:b0:b72:26ec:c8db with SMTP id
 a640c23a62f3a-b72c0ae2034mr313773866b.30.1762517009090; Fri, 07 Nov 2025
 04:03:29 -0800 (PST)
MIME-Version: 1.0
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-2-pasha.tatashin@soleen.com> <d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
 <CA+CK2bDSvtuwrrXGOC07Rj42yGFHWR4Sse7Q5z1z8f1ZFHWQ2Q@mail.gmail.com>
In-Reply-To: <CA+CK2bDSvtuwrrXGOC07Rj42yGFHWR4Sse7Q5z1z8f1ZFHWQ2Q@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 7 Nov 2025 07:02:53 -0500
X-Gm-Features: AWmQ_bnQfOkuuqF_U_UCQyVPI35A_f2RSjbVr-3UOfrbEvw6xE0HnRxARqEhO_0
Message-ID: <CA+CK2bC_+repP-q183hjAuYYB2-Yx7fr_U3zr2cxysAWx5hzpg@mail.gmail.com>
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, 
	tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 516qbyuaan7ipt81ejm79ofijwtdui9z
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DA328001B
X-Rspamd-Server: rspam10
X-HE-Tag: 1762517010-349100
X-HE-Meta: U2FsdGVkX1+URjY+eq+C/s8EOgym8i3gU4qaTYT+gPfIGabPpXxcxSRRUKlIHQ8Kjl7S6hUogvEZWT9+a+QP5zPCR2IeW783APpLFgPpDyrB3mS9WOHZNPPgwv/GSENq2vSYUpKx+f7wuQVijRygIql1SbUdFlZxf0KXc818epzUK7WoeSuan1N8Gib73x6BbBEvqTMDif0g3nxIn0KARaMS5aiGmJkfie7H9zuEjPGJegSr9+7v+TgDwj7zU7sSAmjJQbHlgPD3tpG0ujsweHOSN+OdGGtAKWWt8bZKh4//NEsnkGuOIQvRpI/o0CvjJs3CLcsyHVmJ/w0eLQsq/4S7TyeYAZT8NjsJwoB7zFdCQZTP+WW2mYEe9gLMJBsQDiGpQzJS9uKGl4WZoaniPP2ZgzleeR31Z1pARcoVVTgAQlJnO4/2Eij98cypS559CY1Lc4QWqQdK9lfVF+k1MBZFFykUUJsAs1i+/9MTEmMqdOorVd59XMU2DtIBCkmlJ57ftaOFh9XNAJoZyTBo3zXM5Ip4ppbXA+3/edLbI7dJHQaUyuLKdAvA+Neji3dDz3jJAbbkDSDBE5oNbars3wK0gzm9RhDOxvIqmvph5/DrRWBU6s9n8swHjXX7ls1JkPPsttCUeERLJ1W8/PcB5AvENoqhwDoDHegQX0jo7n7PsmCyWbPHLhBJZAaeWvJCgwkrm1ERlNvyhdwcp2CSkZrMltFstfvnowr9JKxoOBB7khYfnr8qvkY4YGY9+FRQ60p1j/ny+8hbeIyxNUrx57XBjAzWMzZZkBcqH9XrjSF/GbqoVv+YSOyMb0PwxnUNW2ETCn44uca+sfGeVrqy35kvae8cHRuXFOJzgdEnQa/znfPqwUg8vAfnTwmYcdE/AGTVXFEYit8eBXjMT1T3x3w98TQU0ezsbSXk3Flc5+puNjG+/n2PGN3Ix9tMpLS8sYPAIpF8j5sjvBSYe+e
 NL4HeRoh
 6dVDNvoNptkgkjCWw8dtruOuZcmg2ilCD3pUUyShX5E6ALHrdZvN+LwbYv55lf9eMl5+t50pBcXFXqSZWuOfHGC3Atk9hKOoj3Aum0sQZ2GcasI33sDUUSL4CMVWSc2C+SKts259SK7ZG2ZMfkl3TCL/qkEOoRGm35e3KCUswVKB3rq9BuI6hLQo5EM+nV2VGCaTooLg1j38MoWMOpUxEUmNba1+h7bQV7mRILOVoGbI/H/0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 7, 2025 at 7:00=E2=80=AFAM Pasha Tatashin <pasha.tatashin@solee=
n.com> wrote:
>
> > Hi, Pasha
> >
> > In our previous discussion, we talked about counting the number of time=
s
> > the kernel is rebooted via kexec. At that time, you suggested adding a
> > variable in debugfs to keep track of this count.
> > However, since debugfs is now optional, where would be an appropriate
> > place to store this variable?
>
> It is an optional config and can still be enabled if the live update
> reboot number value needs to be accessed through debugfs. However,
> given that debugfs does not guarantee a stable interface, tooling
> should not be built to require these interfaces.
>
> In the WIP LUO [1] I have, I pr_info() the live update number during
> boot and also store it in the incoming LUO FDT tree, which can also be
> accessed through this optional debugfs interface.
>
> The pr_info message appears like this during boot:
> [    0.000000] luo: Retrieved live update data, liveupdate number: 17
>
> Pasha

Forgot to add link to WIP LUOv5:
[1] https://github.com/soleen/linux/tree/luo/v5rc04

