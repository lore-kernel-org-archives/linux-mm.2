Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED75EE6B6C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 23:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977CE6B0089; Fri,  6 Feb 2026 18:57:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C566B0092; Fri,  6 Feb 2026 18:57:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E726B0093; Fri,  6 Feb 2026 18:57:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 780CC6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:57:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F0D01B290E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:57:54 +0000 (UTC)
X-FDA: 84415697268.15.EF38D7A
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1FA94100003
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:57:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=r3FNeO88;
	spf=pass (imf05.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770422272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qrRYtFR1PGHmyWdm1nw1biFHQwk7kZHfuvavlQRdIOg=;
	b=HrgWfFxyfPe14CFC8uNYOXFyxCoyEFuSE1azkNSE7tXcqx5hmacQXcE5Snm6QWgIB2pgLi
	ZWy+7wbDZS0CMCpthJHuZA0HVO3cc74EILfvBoAJrdlPXou7ugzCbYtT/jXsK8fWgGrKV+
	JsDbhlAS08xR7fZtUyFl/qZ1biVZ8k0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2026012301 header.b=r3FNeO88;
	spf=pass (imf05.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770422272; a=rsa-sha256;
	cv=none;
	b=3Jsn/6Q6UFctWLSa6XtCKsgDhHzwTBV1/U9jnIbLRecsRwi8gOWtnX9BArl2/aK33twfHW
	tuFbaV4igZX9sPsZ0NXhfTPX9NuFRhR83sKv3Kc7LPj2EqLCzc66ydsq4tRn+4VCNfxSXA
	yE8ISTuQ0y+QiPdtcDVpvCusRynH8zc=
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 616Nv5wn1409975
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 6 Feb 2026 15:57:06 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 616Nv5wn1409975
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770422230;
	bh=qrRYtFR1PGHmyWdm1nw1biFHQwk7kZHfuvavlQRdIOg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=r3FNeO88r0RrnhV3YBVyg+iBIZuK7drEQKWqvPsgtjVOB80iUpyD9ZWIkp2SVJIeX
	 6GhpYllzsUGTGmGSG4hi5SZzYlxs7uUjM0QDA+ln71Wu2OhfR3NozOo0Q608eXhGET
	 DKr/v+GRHJr20m5R18bjdYsLVUeuQLh6UG7vzxclzO4z7LMNpzExpF3yD+QddoGlnf
	 bucheALVuE+6WxjwWkzddnE/J4Af53zMzfyRGmfpVhnLw3JOONTS2y2/5HkkhVl9JK
	 F9MePpObJToFaZVZlxW5iT8KQnP+crUCszIH00GX9xN6JfQAZiQ9eehxIcXMxLSDkb
	 hsGrh2zK8IPSg==
Date: Fri, 06 Feb 2026 15:56:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Jens Remus <jremus@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>
CC: Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
        "Carlos O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>,
        Dylan Hatch <dylanbhatch@google.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: Re: [PATCH v7 6/6] x86/vdso: Enable sframe generation in VDSO
User-Agent: K-9 Mail for Android
In-Reply-To: <9a63ce89-84f0-4782-90bf-dfd7c8ec8c52@linux.ibm.com>
References: <20260203171958.1522030-1-jremus@linux.ibm.com> <20260203171958.1522030-7-jremus@linux.ibm.com> <f671c79a-ee73-4a12-af48-2811f97b9f3d@zytor.com> <9a63ce89-84f0-4782-90bf-dfd7c8ec8c52@linux.ibm.com>
Message-ID: <1AE3ED79-C094-46AE-B455-06199D5699DD@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FA94100003
X-Rspamd-Server: rspam07
X-Stat-Signature: uyydu5ejgte4bfjn8af7shi3ozoiob3z
X-HE-Tag: 1770422271-315163
X-HE-Meta: U2FsdGVkX18j6jP9U+WNOryR2nvLJr0ErSoq7lwN7XETnUZsvJGvpZlKH7uOqbFAARlamuQWH3Y8ury9cWi4zk3cMUd8j7oXBPtveKKFp2q/Ummn4vBkwgEr+9UZmLpmV2QiY0QbskS67l/zAS8GAI+U/VgDm7SuqywnXdQCt9YkoYoCcGgF5NCPczM+HnViKAqXtelRwuPeQlS7ovHd8uZa/BVFtcaoC22uDZ+/gQsrxn3Li8Z7uVCHeul/ddV1SadO3ybu2bitapldxHVfz2bEDU2HPmvvQqokJcmfJfohkNaM847sLMcFJfj6Kju8q1YakJOmTJU2nO1v4xfAzDQTGd7H58GkiAtkPjROzgDjxgfg1AHyVRTs2sc/uHoAwX6cDXjh6ApCXXjJvd87UIG6tyKOtEGn7Ural3jlNMiASq/AaJca62qNu3O5SDUpIV/MmPyRH9JvS/gxNS7J01Tw1EaDKgmm7+WQf2TTYlDijD+QQM2z7iEbqn0EZpzA8DeJA/wEqc++kDscDKQBMPY40bboQ4FqljYZ51OJ57puwun+v5ZtIQD1N74/awrUZ9Mi1oga0ZKHBWNImsxn6La13yCoQ6Lm6rVyB3cEkR30sdP84NTz1fbvRWS+UQ0g0SzNq4yzfOfZNgDl5glXgwt1IfqUjdAkJCLDMopOZPaBUjYWrMzEKPs+0OL7Rjqx7jYdGr8IBDekXZ0Mx3etMrAjlVx8tYShB7I6UL2tF9mLAtQ+N0IBJpLIle0T66IggOSO9fkM9IVQ/Zi0VTKE/OVhWCQEsg8TUmsJRVIIwmm5qLEImgRyV6iGhVtEbDyLTdSksBfTB+qUISr2Lf6cI6n6qBOklvfqqRCx/ywrdP0NkgGV+iaYWOulu+Mg/5Ds3QnKWFUA2mlftY7ciyjEbTP5RxK0eXZ/z3wvCEsq5ea1iE+g6BIWVPmyVnAJ9QqY4fJ0VZQr6HN4hgOoxoa
 YD5Fs/5F
 5q+7peyfY7NaAJTVzE6W2saoFk94N9ENAZEKBNj/DrAwPru5pWGC+HH8lr4mxF52tdyqLilcSk7OOkVOFry+s3tcsV8udpAzqAu9sQg2PPBBc7EVW74sz4UQqwBjyL2Zfyc0B14Hpo2sd78wh2Muid/J6BW/TLP9psx04908EzXzixPBENEzLf4vo7skSYxqpLU/QCFCpkCNlF7m3IOLiE+poVtHHvowH8lFGRhPJlf0rbCMRv8U3H7PgowWjr+vZm5c0u6Mzfb3O3wUStHTdiJ1LBe4Y4K9GFOvBNBynes2SXqgF7tOLEK0/xucaiEY/wGRgiZO+P+Aakdo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On February 6, 2026 9:48:24 AM PST, Jens Remus <jremus@linux=2Eibm=2Ecom> w=
rote:
>On 2/4/2026 1:49 AM, H=2E Peter Anvin wrote:
>> On 2026-02-03 09:19, Jens Remus wrote:
>>> -
>>> +#if defined(__x86_64__) && defined(CONFIG_AS_SFRAME)
>
>My understanding is that you would like above changed to:
>
>#ifdef CONFIG_AS_SFRAME
>
>>> +	=2Ecfi_sections =2Eeh_frame, =2Edebug_frame, =2Esframe
>>> +#else
>>>  	=2Ecfi_sections =2Eeh_frame, =2Edebug_frame
>>> +#endif
>>> =20
>>=20
>> It would be better to:
>>=20
>> #undef CONFIG_AS_SFRAME	/* i386 doesn't support =2Esframe */
>>=20
>> in fake_32bit_build=2Eh=2E
>Due to (binutils 2=2E46 pre-release) GNU assembler supporting --gsframe-3=
,
>but only for x86-64 not for x86-32 (nor x32) CONFIG_AS_SFRAME is enabled
>even for my i386 cross build attempt=2E  This then wrongly causes the
>=2Ecfi_sections with =2Esframe to be selected (verified by adding an #err=
or
>for testing)=2E
>
>IIUC the =2Ecfi_sections is there to have DWARF in both =2Eeh_frame and
>=2Edebug_frame=2E  For =2Esframe it basically has the same effect as
>specifying the common assembler option --gsframe=2E  Given the more
>specific option --gsframe-3 is explicitly specified I think it would
>be better to drop the changes to both dwarf2=2Eh and fake_32bit_build=2Eh
>and solely rely on --gsframe-3=2E
>
>Josh, Indu, do you agree?
>
>Thanks and rRegards,
>Jens

Seems a lot cleaner to me, too, assuming it actually works=2E

