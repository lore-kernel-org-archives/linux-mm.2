Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4254FCD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 08:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 628026B0005; Thu,  4 Jun 2026 04:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 600E16B0088; Thu,  4 Jun 2026 04:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7FE6B008A; Thu,  4 Jun 2026 04:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 366BC6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 04:45:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D379FC1C82
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:45:43 +0000 (UTC)
X-FDA: 84841596966.25.74CC901
Received: from mout.web.de (mout.web.de [212.227.17.12])
	by imf30.hostedemail.com (Postfix) with ESMTP id B90F180014
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:45:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=TAVTvqNl;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf30.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.17.12 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780562742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=S+hjzIrDTeIODDL5m7s+ngimdUqXBpyiitAoczEsaSs=;
	b=Omxrr4G8FrN/dmVbHAzLE+GuZwE9OL3mKBcM7qRxecxtd/Zl3mD+ZDReC5WG+rSPP+Rzjk
	Gwciz3d4wZmgmWyklEtxD67nzP3ku3FNeFxd31IOOPk/YX/OSXy2JojgFdhYMW0Q0042qK
	ypd0q0Fqp62Dl67Y+NGJ9a0HiqMJfo8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=web.de header.s=s29768273 header.b=TAVTvqNl;
	dmarc=pass (policy=quarantine) header.from=web.de;
	spf=pass (imf30.hostedemail.com: domain of Markus.Elfring@web.de designates 212.227.17.12 as permitted sender) smtp.mailfrom=Markus.Elfring@web.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780562742;
	b=UvDh1OFQBZO4KL+1TMvHJJFyY787kYzUufmTs0rdPQWpy/dLY3cvwl5iW22lHcU0tu65ny
	QNmItG8md2pe8Hux8k1riluWlLLKNluC3vHNq3xQYPRn6exmab68aANrA5IvQQl641Bms8
	0hofun9cqNnTQejLFMAW4x7JytsKlXY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1780562740; x=1781167540; i=markus.elfring@web.de;
	bh=S+hjzIrDTeIODDL5m7s+ngimdUqXBpyiitAoczEsaSs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:From:Subject:
	 Cc:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=TAVTvqNlN9wq4OEuIa7fKBQxGrv2uZg/nYcXn4hzzYiiXr9Y/nYFBdiVB4HeAJD5
	 86Xpk6At0SISUW9VoKdKRYw/qEX4J6r1g7PDsciMnv9w5ylP35iCyaZL0PJVhKEPt
	 xA+dbm8g9EhW85TNKWWEizEuPyq5pByRhzDgOfkb3Ojx69qxZLaH2MgDlZ24XphOl
	 Mn8NU1tbIFSa2tVQs8u0gnIDJI4uwV7QoAqqAyBFg4CbhF1O5f2pwqwdNbuuEmKL4
	 n87W/m4d8b8Lm5ch/W/sgic0+SOojmxneaCatbVin9G3rGncaQ2I7/GUyZv6kfmAj
	 Y4LFLhEx+NjNT3e+zA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MYu1C-1wiH7j3smG-00MfGZ; Thu, 04
 Jun 2026 10:45:39 +0200
Message-ID: <126a924b-6f68-43bf-ae5a-449fb93e527b@web.de>
Date: Thu, 4 Jun 2026 10:45:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] zsmalloc: Simplify data output in zs_stats_size_show()
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jmFiDZfJJ4Gtd7CB5aqbrRA9lWmoW0szILtpZ1pIIRHjjUpIQCc
 IZnr7R5TdsWQGdm4LBw8vnjDKl7X/cMYxtq3q7+JcvOvdKKEc9eogPFW1TacJTzZoDf6b93
 Rl9binAQ/vcQmGGF/JkvqRk7E8aAz4D78obnPzAPi0KCqNeemRrma8N/GPF2ADtvt96t6bk
 yCReUQG6NUPUoSfA36ViQ==
UI-OutboundReport: notjunk:1;M01:P0:Cfx44kd3Ia0=;3y7AoRAty/aFc6xEFaaiqevWzsa
 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
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 87trhenxd1bk6si8ym9nco7jytufznq5
X-Rspamd-Queue-Id: B90F180014
X-HE-Tag: 1780562741-28707
X-HE-Meta: U2FsdGVkX1+PjDPAJJIanZmCjMRwqrUvJ5k43i+5US/OiqqIJiacDPpmaP1U6TERzeTMCV9bI90j+UvdzMpGgEG5Z149CJDCaPHJ/PXQKEwLHhN1PQj15JipuSESdT1rEm8pmMjT3ZrePVnOI3jT4VW5z2dhpSrfg0AwfytCzvXVsTSFpPXrkDv4+FZqxSEqQE4GtN2Tr5UwSXxcKPE84o4xpsKXnEtZNviWttiOnfZ8Hz69zQjFO6kjBLbVdJK7LL0ZNkLYw9wSHh/Oi1+SB9hf6Yo5lY2QgIEYuO7tQJMBPFEfsLw92YRmrMbLCroCIvJnL3qLSoVYvf7qVlQX5epxBLizXqIV7PesjukU6jM3USp5bx/i09AjAt5rLxOYg8hQc4VUBCFHW7BFWsqiNNJAP3RnBc+jARaxRmYLk6zsrn+3sb0Mhvfc6Wi7mOZf0NzWdBNSvFZ6STIjkAxUCRlm1ChJ85FUWc8SjM400HL7KjIok6gZwakvT2fiKwZstdfYlL+pbF+5VcOLxam7BBOZ9jBmySyYyB27fE9jXk7Fe92fyPTiSaehzhnQJbuuRgj2X6lvw56BHGfz5otv/YjTkLUWlMMwTq+mSLOhSfBe+TtrH9zqM73smVl17tnN1sFYihP5RcBVpkvsG+Hq95/c7P3MgnL5JpLh3LEXi+lUGyP8AgB7H5Ml6v5bxQlcYSJaDH0u4aZm3IlzJVCCvayJuZUASNKsV/sN2tnwlOLfVDXJ5qY6IX6EQDdMM/5l9DV1V9DcSY308o4QrBh/Df/sAaiijuCpoG5fmwQgCy4kMr5a+uS4YIXTHzdzb2jzCNst2tMUGD7Ozd8qvPTocUPzlRapodyMVuzfGSd5avEzhPSSSEhZX3NlSTrw8sGfTlH/8u3mrIRwXo/LS3Z6nCwG9nAeE9Am+mY/y+xe1lG2dsK0GoQPmDzz2WMgMIMSH5iVhMKyMO6J4V9QwPU
 vNcX6GO+
 3dTm/sBCpDGZNXDbSr9MCb4ojWmNvhCUJ16IMcy/FPBKGOSQbuHd3plFUB80hbwx8WCt9xlHbJIgx1XU76e7tcrwLoSfVevjeZ0TX0RpUyj7InUjtkCvH28DzEaO/+2Xg2nunCGs7dq0OJzVZHsTkYxeP92fkda3aLIidmcmNN7clbsRwG0PD7lmbSaOZIIF6T7EqoRRNGq8h4ZWf5n7Eo80Kszhz17miqf8QzMwzh1rqkcUpt6oRhXt3vlghBNCv9rjGOWoiLvCK9H681vHgiF8Dn90+tUy13j6ERhEhhlcqfNfQcjC4hJ1cAXL0VtvMflAf7PgvqdtYNCSD3rpMVcMacgWprZ9YvJ9RxDhEAMHfRxmw4vAwKyG6V3C8vcAhb5FK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 4 Jun 2026 10:20:03 +0200

Move the specification for a line break from a seq_puts() call
to a seq_printf() call.

The source code was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 mm/zsmalloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 63128ddb7959..83f5820c45f9 100644
=2D-- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -565,8 +565,7 @@ static int zs_stats_size_show(struct seq_file *s, void=
 *v)
 		total_freeable +=3D freeable;
 	}
=20
-	seq_puts(s, "\n");
-	seq_printf(s, " %5s %5s ", "Total", "");
+	seq_printf(s, "\n %5s %5s ", "Total", "");
=20
 	for (fg =3D ZS_INUSE_RATIO_10; fg < NR_FULLNESS_GROUPS; fg++)
 		seq_printf(s, "%9lu ", inuse_totals[fg]);
=2D-=20
2.54.0


