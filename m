Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 213D9C79F8C
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 13:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2336D6B008A; Sun,  6 Sep 2026 09:44:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20A656B008C; Sun,  6 Sep 2026 09:44:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1231B6B0092; Sun,  6 Sep 2026 09:44:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1AC16B008A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:44:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 457CEA051A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:44:35 +0000 (UTC)
X-FDA: 85183457310.18.A466F2E
Received: from out-2uec-a106.jellyfish.systems (out-2uec-a106.jellyfish.systems [63.250.43.106])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6307D20003
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:44:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=RXiUB55b;
	spf=pass (imf31.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.106 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788702273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LbGshFhBdXlHVEvTyS7w2agrOa89bm05hOSWHkR9930=;
	b=TRRcisc9/yFBycey8CnMAsP3XToDv3zGWFMhfQn7hRtCNzMq60tC37dl8YIHqb5JX01Vjs
	Qc3oTI8zBMLOrHKAQ6JBvxiUcheTde4lx1PykhuktLPT3Cy/uR8gV1ag6bCxWklIQl7Ymj
	lFXyNndDChJ6nnbWKkDAZCRggoG0b8k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788702273;
	b=UmPJntgQOZFgc+n0rN8LmazGx0E5IxBCf8LVDYAU4ry3JqvgGtnsh+p007f7vom9bMG6Qt
	TI19Yhhb3eI7r371TiHSjVModJGvqj45b9FeIr9tzlCZt9n/jZaV55gAWrJW6X0r+xaXN+
	6hM7V6QuLdjNlv4bR+owRyeI5A5SDrE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=RXiUB55b;
	spf=pass (imf31.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.106 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
Received: from mailcore-89d674988-v7w7p (unknown [172.29.60.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.spacemail.com (Postfix) with ESMTPSA id 4hdBJW1TYwz6tkJ;
	Sun, 06 Sep 2026 13:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788702267;
	bh=LbGshFhBdXlHVEvTyS7w2agrOa89bm05hOSWHkR9930=;
	h=From:Date:Subject:To:Cc:From;
	b=RXiUB55bQmAhRdEsg9hEe2uJTxDMP2XlPcAryblqCez2J+zqMejgBd+prwgZG/3lG
	 aG/yWQmy722ix73ImHKwYdEDrK4W7VpwST5aUoKd1Iz6r1skQ9Ijtmu8mrdYlOt54a
	 g6UIjtN1Z1OGfk4ryrVLJzxzmmsnRPVqwPLIZVdz+BJoY7xEdHUa0zqFQ0CILJTd4d
	 Foa48cXWrUobXKypj7ERPtWRuyYVWKFRbC3uyh1ONgxtKiw19MpakowYt6l9YHUatr
	 KIakx1/cwPH92CaXQGJF3aXzhiTSjIZ1OFFlBgZM1ho4n5+tcToRaATGDM7PemFBVM
	 eh36kTb/dBxpQ==
From: hi <hi@tychen.cc>
Date: Sun, 06 Sep 2026 13:44:26 +0000
Subject: [PATCH] selftests/mm: Exit on invalid command-line options
Message-Id: <ZTYJZT7Q8UU4.KPP9BUAAJVQO1@mailcore-89d674988-v7w7p>
To: akpm@linux-foundation.org, david@kernel.org
Cc: shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, jsavitz@redhat.com
MIME-Version: 1.0
Content-Type: multipart/alternative; boundary="=-kkGm76yLaEdrKGE0QA+orw=="
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6307D20003
X-Stat-Signature: i5akmuyu3qsq55s4o54iuky5kywm1pir
X-HE-Tag: 1788702273-884979
X-HE-Meta: U2FsdGVkX19WnqUd6Oc50Q48Fa217oeTYT+oyhGxcLd3ipxD9VUVAMFBc4GoZlSRM+tHggvCysdDMa1yWYTTC+XOgXN6nTJS5N0cgRn18IjFwR0oLXz+hKA7J4UOpZ/oDLD1Ox/MPKBTvvPev4b739CFyJiifmNti3bEt3YwHyZ4AoYxJV4z1YJpZIq6JNV1K0RuDxxBQRDh8V9bUGDyLxQDKqbA8fK9KYAtNVtUflrJlxdy7cRYtgOUnnJ4Tl14mpsTCuuEyDvXFPebZOBrG+n6XkXvFku7Zkt5+EBj/8rwO9gHPqs4RrmK1NWDZsohQjCekq6V5mFGt7q/hVuDpiUYbmAmFICXsST81bJs/WPK4qeNWXnTWYMUppviXFg4o6aTDZ0JFFKIME5xu5ZrbXxZfRxw/SPF+3I4zZwdzk9rTbMpIpJ8BmUciFgTVAKO8txrn6VM2XfI31ZhcZDtV5MkW5q/PE/VFcp3xbLXiM0BaVQiAWAoOgMorY9Lyv1QAvaX9hoKX8CK0j7w9FERN2OXYXXT25QnNfcRfib0iYTlwyRT7FyS/bTcv/K5jX0FCBFj52RwbtzmaOvEYIPfPgnX77qaJMLwRGkgRCim2g9CaCf5DfwU+GzKIDGol3iu1dvq1OA7aQ9keEt2PlJCIECMWeIRIghJ39RBuzNrY3cPvfNr8gVgbSALsns6KRoCdngvOW3N1QQUrBlO63ZTiqceb7DjI7vea2sRR/W03pilmZRVTtRjw22ZYC3fIHQi83aFA3SabTyNW7oKB4D/gvTA+9nqKi2ypiLQgQyYC0j995+QbRJCgSXNjS9d4tTwfTO4WrjijgdhXDQooOdNIeoeci6zBmQ+cQ3vNVwV+CmuwYEK6Kd6Nibg+YXZeduak2Dm7KSbp4OCsTkkj1XgIt/o/8NBcGP7u8FxB9i+u2TPmNvv2otSDHh/mhfPXsdLqw8M3zm9u0PwbCpU62o
 PYMM76W+
 gkKbymgWSQkszkJ9XnKId4ON0O1jlQjRS2nsNCuODSYbF8ZBRuWbUuOwUwFbvsLHLaRm5Ks4v5dsk3PGBJ4ujyg4lMXCgQC5sJUguni5QhWb2RhkM+7vnXgwSEE/UdFKyEf8ZNuqd/8CSZ1UpuRFqjMPIZt5mvAMp9at+2WzcizQw8nRFtuXwNcVjqppZ3ASovOIjISsOzUNAJEtYtyTwXgftwOx5/mHvVm2kKhJBdLXWe+S3dArEN9+VTdrAA+yNrbFlFkrqhDj6sUQa6PPBTsO7b4+Uqif30LgZYOvyxBYK7m3SA3WDCaD1fpwowW4sUZSKgo4rEOL6k9xlDbdWP8GCDmO4WH7Na4GAKVKnNJtM0D3SB3nXBYZYbbbT+qhFjS6f1A9A3pkS9M2NjzN+pPrTcB41vF3FZl38DY4ftAuUMme+4p+nYoX0nkyGBnAT/+c54ex9PSdObvAlSHR+LNgGEwOjFWxcttJsNNXm7Rxl4OrMJYiUZS0QXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--=-kkGm76yLaEdrKGE0QA+orw==
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

getopts reports unknown options and missing option arguments, but

run_vmtests.sh ignores its error result and continues running tests.

For example, passing -z or omitting the argument to -t can run the

default test selection instead of rejecting the command.




Exit with failure when getopts reports an error, before any tests or

their setup run. Keep the diagnostic provided by getopts.




Verified that -z, -t and -t mmap -z exit with status 1, while -h still

exits with status 0. The mmap category's three test programs pass in

a VM running the kernel built from the same source tree.




Fixes: 85463321e726 ("selftests/vm: enable running select groups of tests")

Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>


---

 tools/testing/selftests/mm/run_vmtests.sh | 1 +

 1 file changed, 1 insertion(+)




diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh

index d09f9f6a384..189927f87e6 100755

--- a/tools/testing/selftests/mm/run_vmtests.sh

+++ b/tools/testing/selftests/mm/run_vmtests.sh

@@ -110,6 +110,7 @@ while getopts "aht:nd" OPT; do

            "t") VM_SELFTEST_ITEMS=${OPTARG} ;;

            "n") TAP_PREFIX= ;;

            "d") RUN_DESTRUCTIVE=true ;;

+           "?") exit 1 ;;

      esac

 done

 shift $((OPTIND -1))

-- 

2.55.0


 (https://www.spaceship.com/business-email/?utm_source=def_email_sign&utm_medium=email&utm_campaign=def_email_sign)
--=-kkGm76yLaEdrKGE0QA+orw==
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable


 <html >
   <head>
      <meta charset=3D"utf-8">
      <style>
body,
.spm-email {
    font: 400 1rem / 1.5 "GB Proxima Nova", -apple-system, BlinkMacSystemFo=
nt, "Segoe UI", Roboto, Helvetica, Arial, sans-serif, "Apple Color Emoji", =
"Segoe UI Emoji", "Segoe UI Symbol";
    overflow-y: hidden;
    color: var(--sds-color-text-neutral-primary, #2b2b2d);
    text-rendering: geometricprecision;
    -webkit-font-smoothing: antialiased;
    min-width: unset !important;
}

html[data-sds-mode=3D"dark"] {
    background: none !important;
}

pre {
    word-break: initial;
    white-space: pre-wrap;
}

blockquote,
.spm-email blockquote {
    margin: 16px 0 0;
    padding: 16px 0 0;
    color: var(--sds-color-text-neutral-primary, #2b2b2d);
    border-top: 1px solid var(--sds-color-border-neutral-subtle, #6f6e6f);
}

.spm-quoted-email--title,
.spm-email .spm-quoted-email--title {
    width: auto;
    display: inline-block;
    margin-bottom: 16px;
    color: var(--sds-color-text-neutral-secondary, #575860);
    font-size: .875rem;
    line-height: 1.25rem;
}

.spm-email .spm-signature-block {
    margin-top: 24px;
}

.spm-signature-block p {
    margin: 0;
}

.spm-embedded-image:not([width], [style*=3D"width"]) {
  max-inline-size: 100%;
  min-inline-size: 38px;
}

.spm-email hr,
hr {
    border: 0;
    height: 1px;
    background-color: var(--sds-color-border-inverted-minimal);
}
   =20
#iframeContentContainer {
    width: 100%;=20
    padding-bottom: 18px;
}</style>
   </head>
   <body class=3D"spm-email"><div style=3D"font-family: Arial, Helvetica, s=
ans-serif; font-size: 10.5pt;"></div><div>getopts reports unknown options a=
nd missing option arguments, but</div><div>run_vmtests.sh ignores its error=
 result and continues running tests.</div><div>For example, passing -z or o=
mitting the argument to -t can run the</div><div>default test selection ins=
tead of rejecting the command.</div><div><br></div><div>Exit with failure w=
hen getopts reports an error, before any tests or</div><div>their setup run=
. Keep the diagnostic provided by getopts.</div><div><br></div><div>Verifie=
d that -z, -t and -t mmap -z exit with status 1, while -h still</div><div>e=
xits with status 0. The mmap category's three test programs pass in</div><d=
iv>a VM running the kernel built from the same source tree.</div><div><br><=
/div><div>Fixes: 85463321e726 ("selftests/vm: enable running select groups =
of tests")</div><div>Assisted-by: LLM<br>Signed-off-by: Tianyi Chen &lt;hi@=
tychen.cc&gt;<br></div><div>---</div><div>&nbsp;tools/testing/selftests/mm/=
run_vmtests.sh | 1 +</div><div>&nbsp;1 file changed, 1 insertion(+)</div><d=
iv><br></div><div>diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/=
tools/testing/selftests/mm/run_vmtests.sh</div><div>index d09f9f6a384..1899=
27f87e6 100755</div><div>--- a/tools/testing/selftests/mm/run_vmtests.sh</d=
iv><div>+++ b/tools/testing/selftests/mm/run_vmtests.sh</div><div>@@ -110,6=
 +110,7 @@ while getopts "aht:nd" OPT; do</div><div>&nbsp;=E2=80=82=E2=80=82=
=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=
=80=82"t") VM_SELFTEST_ITEMS=3D${OPTARG} ;;</div><div>&nbsp;=E2=80=82=E2=80=
=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=
=E2=80=82"n") TAP_PREFIX=3D ;;</div><div>&nbsp;=E2=80=82=E2=80=82=E2=80=82=E2=
=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82"d") R=
UN_DESTRUCTIVE=3Dtrue ;;</div><div>+=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=
=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82"?") exit 1 ;;<=
/div><div>&nbsp;=E2=80=82=E2=80=82=E2=80=82=E2=80=82=E2=80=82esac</div><div=
>&nbsp;done</div><div>&nbsp;shift $((OPTIND -1))</div><div>-- </div><div>2.=
55.0</div><div style=3D"font-size: 10.5pt; margin-top: 0px;"><p style=3D"ma=
rgin-top: 0px; margin-bottom: 0px;"><em><a target=3D"_blank" href=3D"https:=
//www.spaceship.com/business-email/?utm_source=3Ddef_email_sign&amp;utm_med=
ium=3Demail&amp;utm_campaign=3Ddef_email_sign" rel=3D"noopener noreferrer">=
</a></em></p></div></body>
</html>=

--=-kkGm76yLaEdrKGE0QA+orw==--

