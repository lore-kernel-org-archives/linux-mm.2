Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7762E66886
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 01:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0006B0088; Sun, 21 Dec 2025 20:46:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6D3A6B0089; Sun, 21 Dec 2025 20:46:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A30D6B008A; Sun, 21 Dec 2025 20:46:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84BF16B0088
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 20:46:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 29D508B932
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 01:46:02 +0000 (UTC)
X-FDA: 84245416164.10.E70B2F6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id AA519140004
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 01:45:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IgvVRb8D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766367960; a=rsa-sha256;
	cv=none;
	b=LMJ8VpISfpNZZ3rlMpvrHA9562aNaOxVQ/lGWcDlSckizoHUidViuDGy7k/+WWFlJyMWZu
	+TO442WV4LeYqGqrv/AxnKRJONhITy3Nfz0nAK/USL2RPC1MyA2E8bgVKBrab6xOt17Va7
	IAAPGDf+ysDd/zsFDDtlsf15Jn9bW0c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IgvVRb8D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766367960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nJB6Sat/52s/CNMT9yMvWPSE3c7rlJLhlxQ8uvw9rx8=;
	b=J7MHLWGbSd97pEgOCVjivhYl/bf9+iUkSHk8ThE7xfCD/AcwRWraqP9znc5DWKKUamtkhe
	sYne7YdgEM9Mqq+r9WJc6NUgb2pN9uHxxH9KKD9YVeIGQFDsAywo+3q0R4XQanbvu3XiDW
	q3R/cTOWtsVt81wz5k4CyupwKJ+TTGc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766367958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nJB6Sat/52s/CNMT9yMvWPSE3c7rlJLhlxQ8uvw9rx8=;
	b=IgvVRb8D+J01hLrSz4LYziJvlHQIlxE7scYwrkH1xKhS/blDHuHEOh80CVMZKkBxgbODpF
	E7vBh0ogq7CPPGkGtAAsV0ud+kF2jvVEURIDLDjCUOWyTZAsdrK2zj3gahOMR8CNtWJ73s
	KtuTV6UqY9ooipcdXj9fezrsy9UbfFc=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-BcE8RSWROausw_AeEuAKsw-1; Sun, 21 Dec 2025 20:45:55 -0500
X-MC-Unique: BcE8RSWROausw_AeEuAKsw-1
X-Mimecast-MFC-AGG-ID: BcE8RSWROausw_AeEuAKsw_1766367954
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-ba265ee0e34so3578538a12.2
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 17:45:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766367954; x=1766972754;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nJB6Sat/52s/CNMT9yMvWPSE3c7rlJLhlxQ8uvw9rx8=;
        b=TA/86SXC4ZM7UPUfhAzphTeIrwAFXnHrJz+CaHiNfn20aZMO2Yw1YvjrViAvAkzTeR
         EjdoqTuZbNKgjBxfse56xHonkVj7pXXQdkN0tEKWuTX8RN3As98JvsabVjGjj2xFHKsR
         7CsgFGOBLT6Xi/O+1K9OKz6w159p8QK8GOOsQkwR9jewuJohj1AjqT93rheKT+GXD5Pg
         h3t2ep79eou8ka96C3+65pBVscPiX+KDrzgHkn3s9REnEZQvl0xvLLzX+JhOyh2vZKjo
         R83zMe69CHqmEPum6m62L3gD7iNkZ7ym7qRWGfaNWnHhvxAI3n/JnUg3myt5V0VYYVfa
         mWjg==
X-Forwarded-Encrypted: i=1; AJvYcCVkqrGg968Tg0+flPHukocs3y5IvrJ821Cc7Av6oF9/LfcxqO4qm0nilf+Kcx+kA0rcvZlnSiIPVw==@kvack.org
X-Gm-Message-State: AOJu0YyCKNtOboW8/pg690oepT97SVkr6DldquuN4H3RZs5kwaFEGIQ6
	6mfzq4wb3ERTTsESRvqObzQDVTdqX+97GA1QeOkEt/TG5wiPctso0WFXn5YPJhzNd6G0A4nKZm6
	tG8r+2pPw5YKOLcTGIm4S8JAEePF6O/SxK5GbpXJcoa0KwdKOBAFbqfWypa0hUC4KKaVhyVWJWk
	k0anXDLMMVnntU4HIhhfDvK86U2sw=
X-Gm-Gg: AY/fxX4iqF5I6NAkcvuPSGJe7mCfK8ehihQoQ6CVx3tnu8Dt5kGbqYDFEG7JlRuIUJK
	EDcooHQZSFmlS6q7HLMIVh3/kWVQyHCIZKpHwl35XWa9THvwrHhHKoW0bC1iNk3VgEIZpx2IJuG
	8tnGR6FAHcg35AlPR5etXTxrNfrruewjOdVqhhP8JbGhZtD7KPxG/xjlBCUrAdJhD5AHU=
X-Received: by 2002:a05:7301:508a:b0:2af:7429:e53d with SMTP id 5a478bee46e88-2b05ebf88e5mr5345519eec.10.1766367954083;
        Sun, 21 Dec 2025 17:45:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHCBWqVsapONNRea9BKHJV2jQFdLFXvNDn5VCkIegnUhkljoDAAO5m9Ok/mlEnNrihMaJ3hNHw9Ky3TbfJ6MN4=
X-Received: by 2002:a05:7301:508a:b0:2af:7429:e53d with SMTP id
 5a478bee46e88-2b05ebf88e5mr5345502eec.10.1766367953670; Sun, 21 Dec 2025
 17:45:53 -0800 (PST)
MIME-Version: 1.0
References: <20251221122639.3168038-1-liwang@redhat.com> <20251221122639.3168038-2-liwang@redhat.com>
 <20251221221052.3b769fc2@pumpkin>
In-Reply-To: <20251221221052.3b769fc2@pumpkin>
From: Li Wang <liwang@redhat.com>
Date: Mon, 22 Dec 2025 09:45:41 +0800
X-Gm-Features: AQt7F2q3Gord7vebrD32dnNAsR5HLmi3eY2E6lC71d3Zho6nx9lidqAeoSL3tfY
Message-ID: <CAEemH2f40t+4SsjL3Y=8Gid-CBMtf3eL1egsPKT1J_7LDbdWPQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] selftests/mm/write_to_hugetlbfs: parse -s as size_t
To: David Laight <david.laight.linux@gmail.com>
Cc: akpm@linux-foundation.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Waiman Long <longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3zF5xufeZ5QUyOMTFOFhQ4LtRJQZ8ja1vU4VVt9D6r0_1766367954
X-Mimecast-Originator: redhat.com
Content-Type: multipart/alternative; boundary="0000000000006beb3e06468096ae"
X-Rspam-User: 
X-Rspamd-Queue-Id: AA519140004
X-Rspamd-Server: rspam10
X-Stat-Signature: 78x6mqkxdm1rti1kr3sx5b7yskujf6sz
X-HE-Tag: 1766367959-721366
X-HE-Meta: U2FsdGVkX190/ikb5PX/MFKe27/1ED0c3nh8EVA1KCHHQgpP5K5nyqOegsC3YngEnDfoJijuGZdWrRRHANoMXFGaBCO+rrMEUOYhwN9wJ2ZD22Ble7aLCHkYg9JAxIvQKCqnKBQn5qcpBFslbsSaEixsSz5I46lJrzNb1+7BVJiWOP7ztbhKlspLZ6sBgBElR7vuoyaT8EzPYR2Kj0R8hRLks8DJfkoulP7QUNgHd2uXzEgB22vPDdKnJ3GR8FB5D4DleS5oNf1NQlDVDKJlp20DCjpAtQPbWc0nFWeBgOs/Tpz9eIZ+dXfzhG4YXByORPmPHhCWwlmSa6tIAiA7Gn64X6E4a8kdZLJmkP3afGQo2HQMx5cf4U4CzftiOxExXPx9rptBPWdMjTTa0/MPwFqXEBd1oWrPdrC0ukbhUFiFuvMXhXlig0v05pnfQvQtQKQl3ZZomhbzemhYwy1iw/E3vZiFzwLslLp5UB+o4dHU15iyb5jYsXTJ/89qirl5RQY9kG7BN4SsG0ROsKNeUfC/A8Qo0iaRX527SGGa31YobZ8uYbt8fj+eALsSvO052nCoYEU3vqwmGsAIi+R9yJ5UqGDxniOvs/sAxt/zpYV6mX/qbnAQvsZ8nV9eXIDDFElx8s+3ddlAiIkXvk+L7LEdk+RwkZZTCNIEnRG2PA0CZlhzFqmA92qye0tM/stXg7CD6vZ4FQjo7jkSAS65ztrCrfjuoXnl8mJfvAcvSiB59R1oPUo7umyImQG2wrz6ThYM6uARGX8RhxtyLOKl7jdF6DBqtWcgvw5FSTi95BnlIn+wajw7DP094QbrMTj0Q0Vf1vjU+QqTCVww+Bk1bvpc+AaYwmnJKaflYuPSqFYx+i92HpmpOLeBXg42g6P4/2bLXK4nSegHx/nUjZ0/2ZjY3Ftqsn2oWhzDw7Tgq3ec01Jo+1RBUfMLLww++u/e7DS3o5nZETSSwr7+LgI
 y3NJSl+9
 ABq41H2jzmpGAwhA5bHVRoKRibIyeJz5uEZLotR1nZbGzQJayNzaNFKEN4pVrkCZeT6HGVDic4NxWV/HJ4BaOhkm8gCOeDacRlxrt0EqUzuOqbSeZ33GGYBdUan8LqAUA13yEUd4VUYBaUWeYF7bpgQ5TlgTa3KxCcGaVBoQ/P0Kc0wSZiLYsm1R5aA+JaKrxobtbnIQVwKXNdh5XeSEW9Yrfo+H0tBdGJMw7Fr7sxcMYPPxNObS6pbXG1hBeMuJ6W260HW/UU/8RvCxNxvTxxIrR72gmTHHCSqIUB29OtEwl4bWfK4svkBeq0MDm3GHETdtYc248Be9KowqCtLLw9mRUrrfiQ9OayHY3j+JnxDmjz8Th3UqojyMsKRc4RJUhDuH4P/z9RQHrc58fhqe7nSBm+NHo/WKcYBMeL6CSFDB72kIx0festKHPbGKy6IxIOzQPAuN45yJHZ618kXdP7yHSan2fgWOCffldrn6NOT9BK25mrW1XZ9C4uo+ZtobvD9Y48P748t/+q66COD9rPDMIIkegfaR3B0kVWKuoEkKXfULJo3+PZARuADF38S9pnbeqJ1IqjjlT4vuC2G74ZUxJXdieNMRfzIsX/IEWwVuaEvVdX3kihsVwiy8MdsmnycFIDtgcAalWnwcRY1b/KbAP1APcy1qpCewI/vULQly42vrpan4dPowsJ7oYkPtGmuHeKY43TyCl9C+wZEGmDwG1lKs3ZE2Qsp8+zVrbcFekDZr36o5eEKXIyntYrRt33RS857AJMa+tbhJ94xzRccDE4IXg95HpisFIPMjNk3RBDmo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000006beb3e06468096ae
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2025 at 6:11=E2=80=AFAM David Laight <david.laight.linux@gm=
ail.com>
wrote:

> On Sun, 21 Dec 2025 20:26:37 +0800
> Li Wang <liwang@redhat.com> wrote:
>
> > write_to_hugetlbfs currently parses the -s size argument with atoi()
> > into an int. This silently accepts malformed input, cannot report
> overflow,
> > and can truncate large sizes.
>
> And sscanf() will just ignore invalid trailing characters.
> Probably much the same as atoi() apart from a leading '-'.
>
> Maybe you could use "%zu%c" and check the count is 1 - but I bet
> some static checker won't like that.
>

Yes, that would be stronger, since it would reject trailing garbage.
But for a selftest this is probably sufficient: switching to size_t and
parsing with "%zu" already avoids the int truncation issue.

@Andrew Morton <akpm@linux-foundation.org>,

Hi Andrew, I noticed you have addedthe patches to your mm-new branch,
Let me know if you prefer the "%zu%c" enhancement in a new version.


--=20
Regards,
Li Wang

--0000000000006beb3e06468096ae
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-size:small"><br></div></div><br><div class=3D"gmail_quote gmail_quote_con=
tainer"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Dec 22, 2025 at 6:11=
=E2=80=AFAM David Laight &lt;<a href=3D"mailto:david.laight.linux@gmail.com=
">david.laight.linux@gmail.com</a>&gt; wrote:<br></div><blockquote class=3D=
"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(2=
04,204,204);padding-left:1ex">On Sun, 21 Dec 2025 20:26:37 +0800<br>
Li Wang &lt;<a href=3D"mailto:liwang@redhat.com" target=3D"_blank">liwang@r=
edhat.com</a>&gt; wrote:<br>
<br>
&gt; write_to_hugetlbfs currently parses the -s size argument with atoi()<b=
r>
&gt; into an int. This silently accepts malformed input, cannot report over=
flow,<br>
&gt; and can truncate large sizes.<br>
<br>
And sscanf() will just ignore invalid trailing characters.<br>
Probably much the same as atoi() apart from a leading &#39;-&#39;.<br>
<br>
Maybe you could use &quot;%zu%c&quot; and check the count is 1 - but I bet<=
br>
some static checker won&#39;t like that.<br></blockquote><div><br></div>Yes=
, that would be stronger, since it would reject trailing garbage.<br>But fo=
r a selftest this is probably sufficient: switching to size_t and</div><div=
 class=3D"gmail_quote gmail_quote_container">parsing with &quot;%zu&quot; a=
lready avoids the int truncation issue<span class=3D"gmail_default" style=
=3D"font-size:small">.</span><div><span class=3D"gmail_default" style=3D"fo=
nt-size:small"><br></span></div><div><span class=3D"gmail_default" style=3D=
"font-size:small"><a class=3D"gmail_plusreply" id=3D"plusReplyChip-4" href=
=3D"mailto:akpm@linux-foundation.org" tabindex=3D"-1">@Andrew Morton</a>,=
=C2=A0</span></div><div><span class=3D"gmail_default" style=3D"font-size:sm=
all"><br></span></div><div><span class=3D"gmail_default" style=3D"font-size=
:small">Hi Andrew, I noticed you have add</span>ed<span class=3D"gmail_defa=
ult" style=3D"font-size:small"></span>t<span class=3D"gmail_default" style=
=3D"font-size:small">he patches</span> to<span class=3D"gmail_default" styl=
e=3D"font-size:small"> your</span> mm-new branch<span class=3D"gmail_defaul=
t" style=3D"font-size:small">,</span></div><div><span class=3D"gmail_defaul=
t" style=3D"font-size:small">Let me know if you prefer the=C2=A0</span>&quo=
t;%zu%c&quot;=C2=A0<span class=3D"gmail_default" style=3D"font-size:small">=
enhancement in a new version.</span></div><div><span class=3D"gmail_default=
" style=3D"font-size:small"><br></span></div></div><div><br></div><span cla=
ss=3D"gmail_signature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail=
_signature"><div dir=3D"ltr"><div>Regards,<br></div><div>Li Wang</div></div=
></div></div>

--0000000000006beb3e06468096ae--


