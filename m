Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADED4606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LX+OZYwK
Received: by kanga.kvack.org (Postfix)
	id C35886B05EE; Fri, 20 Nov 2026 03:43:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0CB56B05EF; Fri, 20 Nov 2026 03:43:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC636B05F0; Fri, 20 Nov 2026 03:43:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C73B6B05EE
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:43:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0ECC480E65
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:43:29 +0000 (UTC)
X-FDA: 85454858538.25.B004226
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2250D12000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:43:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LX+OZYwK;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of sendavianemail@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=sendavianemail@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795164207;
	b=lw0c+zlfqkbsfgXUdVZRvsRqhDilXxJrgX7SCiK4JY03L+ZCEAC333l0sSzhhQAXzcrCbt
	vcV0MYCFu+0Al0GR4PCUr7bLKBnP/O/8X/2BA848HN7BprNPnJtCNhvDXs+PE7uAIn26cM
	VX53rb1kZQKHpAeZpMgJtwCJaxz3ccI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795164207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFX5SbWtQIz5sbpoWT0M5kUmCBGDjWyQsTnra57duRw=;
	b=ov/6B54zqq4ltozyl7ZqsE3VflU4KKIb945E6QAVhEFkDRWJXqfvnVRJ6sOHBVVgz80clg
	FiVcCEej+iXIn47V4Kz1QRPcUbh2YsHog5pyfNdij9Nvg5A0tqVL790BO2TQufp9nccdIx
	9dAEhP/30sB5RWzvcY1Yjh+K9DMd9Qk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LX+OZYwK;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of sendavianemail@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=sendavianemail@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-67db23d8892so804822d50.2
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:43:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795164206; cv=none;
        d=google.com; s=arc-20260327;
        b=UuItmcIvrHQ+9JLfwmReaGT7DrA/Wkjo9Su6ZeJzF/BEKd/D8IgiuZ0ZjZOGuqkQtD
         qZFZSJO8gFNCIXxdCkFARoSApKqHN7l4SrzL97gzNx/NnSxLQR7F9z9SQZmiC2ZeHS1O
         LE/3WYcUdapj0kMSm7EA8mwJ8n/jULVZAznGsPBpaFa0V9roo6xdzLL9mVqMzHUwOkUn
         LOqmA4ouNROgLPrLIWPkdM3WIpj/LzLt30IEjiJwVpx+L1EOEi3PZRv+MvSQY5v5ZY2m
         8skN4zeCzaplSQNC3+bZ4DAg6PytuJq0cJLcwnd5QWHmj9sixSfapnroMeMkiDf1ePC0
         SczA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UFX5SbWtQIz5sbpoWT0M5kUmCBGDjWyQsTnra57duRw=;
        fh=JbgAJW+RFZzOX2T3nw5xriFLgvfRBrRVwuieowywfrk=;
        b=QPqPTQY+cgoohKYqDswKd0V9mHYD1pMwuWY2H50b/Tjaw+qIogshnKfKxzpCmOSn6k
         9L4IvOmFWWtgT3JyqpFwoDVMKj7GhKppXzETmsmxH7OGmeXshhDexmHU24G3Th6/c7Ix
         hoiS7ucSvmyf8lEpzvBA5CEnlQFVdf+iPBvkuZ/g3Pm5vNMOl7nYMD1D+1h2IE1mXQje
         SFbFtYyZD6qjwuI7U5j1cIerMhjytt5FGgfy7FbzXOaIRUKkOwptIoUDCbRSIfq8e2Pd
         kdJZ36lmRK9gXpMu7sDBWOO0mB775HLzwIj5fXajFGVPtQ5OiI7qv4cmDz/pun+5Rw67
         WyiQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795164206; x=1795769006; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UFX5SbWtQIz5sbpoWT0M5kUmCBGDjWyQsTnra57duRw=;
        b=LX+OZYwKVi/p1x0l5NTbAMX27J0SvxkkiB9sOE5ejmW+y8bG92i8laYwJrHKEAUYIa
         /sZecuKB7qW4TP6Rcdbknd4xvDWKZBSJ9qub6vGZhBlZ98Jaf9/TnZe8F7Cox73Y/S55
         oDVd+WK2bbiwJF/KPGTt+bsuM02Ip0pUjRvLup5shSu57oVnObIr6EZgCrn6E92UVjKK
         RmUwVbXYP4XLv0I7Zg/Dk4Vw+uaqcKm64wLs4Y5nSiemWzwc89ECXW8hF1xaIlYTPdON
         59D5BzSAVNENorIVMe4am/VLz/3aOqnYGk+VP4o/EZPgcZqlnAuJx4aJacmgVjQxDjbN
         /0kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795164206; x=1795769006;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UFX5SbWtQIz5sbpoWT0M5kUmCBGDjWyQsTnra57duRw=;
        b=hlSio37ab+cLmCA3hNV9iCSubkz4Gm0pRgpzdiVMjldwhgZf44uzbiyHbT0FyC+xok
         2UIWgi/zkGU4FVoqRp1/PDVGy0N562QwOheWVVxtDV8bUlmHu/A2fC79y9MhDsORX/ql
         uNoAby35nkG77BS/yty6Vu8L0IFRApjIfLM2+f0oJ2Skt4mmdYfHcKysg+sR6S45xrsv
         rM/NtkZBCPgRPR9WbUhaF3hXKJj7NiV2Et62LbH7ajGsaqkRBagWX6s7/Qye2XNwtlZ3
         NagTJ812om7DMkqcd/IwqMsNNS6kTWyTqb1/Huu8QxDCVEMjRqi+DZutMvCSyy2SpJZa
         5CHg==
X-Forwarded-Encrypted: i=1; AL+hErFU8LjNtKNz1SGoyh8aqgdRkbYecyB8VeR3tknCKQl3qw2ZaI4KYhjOuMH60Jy9gtl+bYTcAK63WQ==@kvack.org
X-Gm-Message-State: APuU4Z9CYOqTUB2f/3UHsZSB/FXKc6ZqZ2VyCpwi6M2RjbUudgn7LZ79
	zzpL15kPHfU3k3X2aO5AjDrSd90kvcdYAHH6Id6HrvUrn0IvauIfdqVw8+5lYvo7QJfChd05hZA
	PKHy6umv2ACzYCLNx6FHmV1I82kHgBkNkzAEjeBE=
X-Gm-Gg: AZFdTZcl9D5Nw7D05F9u6cRECAbB259fFDqDhXexAWGW6z9VtQGnIQatkApkrecquUI
	tCO9JH5x1L3xoxG2Z9VgqKzRGiyJiQCkGifQVUQDYgTwRpZJwOhn8wIf+47fJ7CtXFKYp92W7ts
	gUkxpfUSxDRjWXdUXLxDkTYMizAowJp+D1LUWHmEa571dS9KGHQ4Vdr1mWIPQisDLDalIEizQOw
	jyhvO0K9TmAUQ4BKTyjablIK8o3ULObB083yogS8PafnxjiqxA3PkN1ktibWpfbQ+YODiljyEXU
	8rZ/JDro9h6pQfPs9SppUn+EurLmyPIHycSWVTrYhC+1AmwXsbyELdfmSkGrDFscBjAZ3CG1gmH
	0KGyWPbPLX+03EwZTLG88MgDIaXP/slul3nT66TBEFMLTHrVnfK34Hu9LrFvU3ylwM0M=
X-Received: by 2002:a05:690e:1445:b0:67d:a102:b8f7 with SMTP id
 956f58d0204a3-67df42b4ce4mr1701702d50.6.1795164206146; Fri, 20 Nov 2026
 00:43:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119180015.933433-1-thnkslprpt@gmail.com> <av88TW3GQRvXJDwA@gremlin>
 <CA+jvY9E3XD5mJZ7V-+6HFxEkY1FHNGom42F-nxMZNGtOy9POqA@mail.gmail.com>
 <8e56f690-7031-4a57-abdd-a02c1c94782a@kernel.org> <CA+jvY9HQp6iDPGDTuVqrQNnw0ENDDq46_AwZqzcjXNcyFWqPsA@mail.gmail.com>
 <da01ae71-8b99-42b3-9a46-d7e39c1eb981@kernel.org>
In-Reply-To: <da01ae71-8b99-42b3-9a46-d7e39c1eb981@kernel.org>
From: Avi <thnkslprpt@gmail.com>
Date: Fri, 20 Nov 2026 10:43:14 +0200
X-Gm-Features: AclHuK8rXBcJ_8ELLgyf2xtzrczstnaeZcmpb4yEdFgcoImAxHU1ApPCKG_mdBg
Message-ID: <CA+jvY9FG_G7ZPjHi18rWS=qcX+9-OppR8jb-cV7FJTQ6JgZrLA@mail.gmail.com>
Subject: Re: [PATCH] mm: skip temporary folio allocation for anonymous UFFD
 missing faults
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	liam@infradead.org, mhocko@suse.com, surenb@google.com, vbabka@kernel.org
Content-Type: multipart/alternative; boundary="000000000000d237db0660b13c58"
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2250D12000C
X-Spam-Status: No, score=1.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FROM_LOCAL_NOVOWEL,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: rhk9dsxjzpgtghqg15xy6ejbj1nkmhxt
X-HE-Tag: 1795164206-755783
X-HE-Meta: U2FsdGVkX18wozovbVGfV3/iXBcO3IqiVoT8+/aL0Ewh+u1AwpnzB3wo9FpEAgukVNgE4sRrYy1bWZvU5cN7uTnpnevdl80WH0jDglvbQ4ZYdGN2Khqw/pQ62xaDXuMxDXG9nWw0N7KlM/LhD0bG3VRKBTsypCn4CZTBpaghxcTMhV6y7nj+OIDNvAgqm48YVLi0+knsuurA93xDF0Mqok9cXJb01fyWMt5cuxgZDxGMg2K7Nm+LOOilIuha8ivm+a3ALCEdUqjd/kJjH+XnWb8DtmTycso1fwKreciwKxmb6tJbIJikGdO7A7lTNK7l9UqfQri4aBU8KPeiznnsSSARboZzNDt6w0EHZfeyrRRu9sRzPQfAbU9kQ7nZFkypg6yXRRicmtmUBDW1p4nohPCAGtCjnAunNNj7MDmpaCnSogWEPjknk9aZ0k6Mm0DcVLS50U9sak4/x0TR1gwKAxYoQsjmwbU0UO16Z0ioL0SKsyr8inn4jX14b7b3AxPmwFBTdL8nBEfWjhSwlSJMVcA68/XtrfB/kL6uDq0veG/ecRRQngL8ZWytvoQUSJ70vncSrKz5ZMTYL2LAjJjHOeSVhBoPVt/S4gEtncV0d+KgmcPn49EWIPTAwR64E2224E1Oh7gUUtX9JoYQsx5KP2Rjx1YfT86+90ZwU1YmoObdF39ahfQhDkyhy/UF53aQFD1izUS8ZybFS8V+rasT6rucF9hoD+9YwqO+Spz+zUSc/K1g8AEwccdQHLwcWDnCZWJHDiUupgNtMuVY8cNSrvHnzBqUorpHQpjP51J3ONlsH5JjfMQ6nrVXDxO7/sL054TxlS06UDfmF8hExDpBvjBOKxC/v6IWhWs4pYrHWPH5izcP+N0Vlt9Iyy8PysG3Cz9jRbOfYiQYaqlWHSowsW58F5z50NFT3K6Ik1m6DNBhMFuqHBgPXsL5EqeFmnoHJhczqFihCqqHUFfag2I
 ZpQ0qX+V
 K/CDUcKLQF48ZEOFSS5ePdVbbtjtMl6YKJewm7OtiXRNuvIGGjNtxnEs7edAAdMOBYWqElXmVSNrPuvCeXF5PtOxiSE9Qo1xpdQhQcuPwT3nF13AJM1/fw4lEHeaCngQi14Wyhxc0N66plBJ2alPYkDMhwvbdKh7Oj6ynVrVKcdBbqDtJI6RSeHhDx73zNr5Zs5LCrbs+gtTaXvYzptXU+5lv+5XqEWz0Gv38T44J907835nOvTmcLLhl+AJDFcnmIZQJ6fRRo7Zb1/ufFmoRSG5ej0uTq+wY8+e4r0P7yHibQY6Y6HgZvs6lRmPsH36dZad+DvmSeV/BoMq4+MRMVf/yT2/2gCYeXdC0ba5qCSWoUtVt3qEabKCf1WMX6vr8gl+B2IFuQPM3l4/t5HAUfieOpsQWOHY5H3rl25AdQL6lxInbXHocJbNMowNqZrKj/IweDBpjHkHVW/sqSWWJdMf2Zha+dHeblyqgi2kE85jvJlpupW8UL4EWYCsLMVo3VoX8V3VaaLW7rZBaUlxAhhmfbtrEEHnihqFIp6/J1Q117POV+6Zc7WhBGQ5NZUJbih4lz4sSM8OUG+yK4U/k1gEsIRyUSzLZxl3AuCSSCq6jH23A/HozGXpjtxZZYy7kt+DE4sMZlooyxG/8giScXF9LiZF4xqWhPgbLWQ3Q6lfqpWSBaSFNm+1DnltuA653jYc0ANvCGVCx6KCr4+EU9tTaIPEHcOHoiXNRPzMHbys/16e3G1uScfZnMqk8D86PMmQgGOmSiMJu51Z6VDwybLhl4Z8M6d4nDW0cUE9CJeQ6YYUqS/CzNaiPDXOp+GcfJUPCdya9TYQzYod6XYkywnY5jTarbw73Q4dFrdWyPJdliO043FAmYamQggYvmyrL7WkvraLGhCZo6Sfwc6AJEtfWA7CWc9DPZnbq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--000000000000d237db0660b13c58
Content-Type: text/plain; charset="UTF-8"

Thanks for the explanation David.
The additional context helps me understand what contributions make sense at
the moment.
I'll take it into account.
Have a nice weekend ;-)

On Fri, 20 Nov 2026, 10:38 David Hildenbrand (Arm), <david@kernel.org>
wrote:

> On 11/20/26 05:20, Avi wrote:
> > Hi David - the real motivation is very simple - avoiding the wasted
> > allocation (if possible).
> > That's it.
>
> Just to clarify: we are all right now completely under water with fixes.
>
> Optimizations "because we can" are not heplful. They cause more stress on
> maintainers and reviewers without possibly benefiting anybody in practice.
>
> But that's nothing new: we always required a good motivation in order to
> spend
> our precious time on proposed changes. Because maintainer+reviewer time was
> always a limiting factor.
>
> While your changes might optimize some uffd workloads, they make the
> kernel code
> more complicated.
>
> "Because we can" is not sufficient motivation to do that.
>
> IOW, if you don't actively run into a problem, there is not actually
> something
> broken, or you have a real use case that needs solving in core-kernel code,
> changes are high that your submissions will be dismissed.
>
> Because we simply don't have the capacity to engage with that, sorry.
>
> --
> Cheers,
>
> David
>

--000000000000d237db0660b13c58
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Thanks for the explanation David.<div dir=3D"auto">The ad=
ditional context helps me understand what contributions make sense at the m=
oment.</div><div dir=3D"auto">I&#39;ll take it into account.=C2=A0</div><di=
v dir=3D"auto">Have a nice weekend ;-)</div></div><br><div class=3D"gmail_q=
uote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, 2=
0 Nov 2026, 10:38 David Hildenbrand (Arm), &lt;<a href=3D"mailto:david@kern=
el.org">david@kernel.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204=
,204);padding-left:1ex">On 11/20/26 05:20, Avi wrote:<br>
&gt; Hi David - the real motivation is very simple - avoiding the wasted<br=
>
&gt; allocation (if possible).<br>
&gt; That&#39;s it.<br>
<br>
Just to clarify: we are all right now completely under water with fixes.<br=
>
<br>
Optimizations &quot;because we can&quot; are not heplful. They cause more s=
tress on<br>
maintainers and reviewers without possibly benefiting anybody in practice.<=
br>
<br>
But that&#39;s nothing new: we always required a good motivation in order t=
o spend<br>
our precious time on proposed changes. Because maintainer+reviewer time was=
<br>
always a limiting factor.<br>
<br>
While your changes might optimize some uffd workloads, they make the kernel=
 code<br>
more complicated.<br>
<br>
&quot;Because we can&quot; is not sufficient motivation to do that.<br>
<br>
IOW, if you don&#39;t actively run into a problem, there is not actually so=
mething<br>
broken, or you have a real use case that needs solving in core-kernel code,=
<br>
changes are high that your submissions will be dismissed.<br>
<br>
Because we simply don&#39;t have the capacity to engage with that, sorry.<b=
r>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</blockquote></div>

--000000000000d237db0660b13c58--

