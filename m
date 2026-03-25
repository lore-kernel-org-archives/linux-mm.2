Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6C7A103A9BD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81BD6B0092; Wed, 25 Mar 2026 07:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E590B6B0093; Wed, 25 Mar 2026 07:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA706B0095; Wed, 25 Mar 2026 07:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C06B26B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:36:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 575515B818
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:36:24 +0000 (UTC)
X-FDA: 84584382288.01.675D6BA
Received: from eu-smtp-delivery-195.mimecast.com (eu-smtp-delivery-195.mimecast.com [185.58.85.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5E823160007
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:36:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gsacapital.com header.s=mimecast20170115 header.b=bohOWLCB;
	spf=pass (imf08.hostedemail.com: domain of rushil.patel@gsacapital.com designates 185.58.85.195 as permitted sender) smtp.mailfrom=rushil.patel@gsacapital.com;
	dmarc=pass (policy=none) header.from=gsacapital.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774438582; a=rsa-sha256;
	cv=none;
	b=FI7E3jJuOL4jxpN465SR9NPasj/jaSL5pWvxLY1sRdnQxqp211jdaNMxkEfoOg+rdacOwg
	wS0EP3Pc8a5mm0xjwKkrjAsMapZt3qXFLUNAtBVt6D2pwtcLkmif+TyvehEPad0ZcDId/B
	GPCF9BWhIb9NVhbnlzvpDLQw0QtxGR8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774438582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUVSyEDvebuqZuvn/YoiC1PqlwIm4XkHWHkdGzIev3I=;
	b=6lRUTUyuEtZrAkPjCVR6xbisNtdg1z0J+KXYsy2X/0CCieyPkz6wanV3g1aC0yt0Gof3xP
	0385crD4Gr9+m4oJGU1AvFPAh3+L0x5oIrb4dFuU05q42R3aKfvdEvNUdPmEYsRf0/pjhB
	nwPxBluE4GIwTmJn8hepHDo1nVBP3zY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gsacapital.com header.s=mimecast20170115 header.b=bohOWLCB;
	spf=pass (imf08.hostedemail.com: domain of rushil.patel@gsacapital.com designates 185.58.85.195 as permitted sender) smtp.mailfrom=rushil.patel@gsacapital.com;
	dmarc=pass (policy=none) header.from=gsacapital.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gsacapital.com;
	s=mimecast20170115; t=1774438581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yUVSyEDvebuqZuvn/YoiC1PqlwIm4XkHWHkdGzIev3I=;
	b=bohOWLCBarWPoLPAUY8iznoo36BD66IOqfckMLKOJodMNrgT2e7PDJik8UK2HvAYL1mKmc
	1uTiNA5b2AnqjXpLvdm14KTwJYRX4yqveH+NRwbHgcp6MyaJ2h8jSnu1iX6JWzZ3vavDOg
	SozI3VE86bGD7ZL8xEsnkNb/ep3TDb8=
Received: from mailrelay.gsacapital.com (185.137.2.10 [185.137.2.10]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id uk-mta-160-b5qONeUlOTmmFbnNNarSmg-1; Wed,
 25 Mar 2026 11:36:19 +0000
X-MC-Unique: b5qONeUlOTmmFbnNNarSmg-1
X-Mimecast-MFC-AGG-ID: b5qONeUlOTmmFbnNNarSmg_1774438579
From: Rushil Patel <rushil.patel@gsacapital.com>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Rushil Patel <rushil.patel@gsacapital.com>
Subject: [RFC PATCH 1/1] mm/filemap: make writeback wait killable in __filemap_fdatawait_range()
Date: Wed, 25 Mar 2026 11:36:16 +0000
Message-ID: <20260325113616.785496-2-rushil.patel@gsacapital.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260325113616.785496-1-rushil.patel@gsacapital.com>
References: <20260325113616.785496-1-rushil.patel@gsacapital.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wNSDKIkEE6OLVTDiMeTktgRqBoA9izFxNFulhn1YzfM_1774438579
X-Mimecast-Originator: gsacapital.com
Content-Type: multipart/alternative;
	boundary="MCBoundary=_12603251136201591"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5E823160007
X-Stat-Signature: sro35czdcgq6iunonq6w6b57koxqpgpc
X-HE-Tag: 1774438582-305961
X-HE-Meta: U2FsdGVkX19hP/F9Wg1cVtGRcopJvAD1FSf9cemA+xLHTGKRRw5IkR8l342kdqC0oKgShb8TmQhmXYvd4u6NhhJC9VN5XjaMo2u8QaZjIFXwZzUTAocuK+yfvK8R1BwRYPs6UYfAg02iKX4weuoL4fY3KBo8JqslM1kJ/U8cWWZpP0YydbuOnte//n8IzelGkkKoSJFor56vh5jIKZDzKreqppTFTNfHkUkXrHNYk2gJNd11Rzg2Y5Kn3FeOl33a3zSFPaM74TwBkaac0plVmY5nucTFYQfIQk6cjAnTy99IWpOuNVra/tnsYKJmE1B+FYpjjPmrzJ9UEr7UUIV7FbKjBEFTa+YZ4efH8WeephWEPuWgrzrvt3+/CD/q1bBl8QxGWEcoxQDuRSujS7tk9YnjVwjCwq2SRBtQNY16xsc/QdX6EjFtPrrKLXJgaUzjM1hBifgKRzLcOusejcieWGtXtr+vL4IBqJrWS1cDXNOSgHwW08OGerGMsIAGXlvygSd/WmTps9308Klw2h3wSc/jCVkLcu9YDiNJ2VU7nd5yIZqywKRacqwEjTuyBJPzofTB+uY+cncH3rFRrnGOP4k8tmydtybIf/4V67wPKoJUelTYOkGRM2EQsnZ0SAGtxSRuT5ZkhxourYD40wEbW7x/RbvVvj/b8nvRl+hWQto/9IyiwIaj/EyY9GjnRTla9SSDu6IXXQ1dQCnWtaiXSlChjp7iiv/v4uuotRJlkyksfMcWWxbluFNGzmk6nmy6uudyyCmQ9nzpHnK7YMk7EyLB8zfyX8A4IuTXq+TZ+055e6Gm6Jvu634/tn26TUnnADZyTQtweaKbWQiFP/kzBHKLM8O4gvp65N+VkqW1svHWnyoWHnxhfDl1rYRJ9SVYdzoaxw53jipVkW9VsWPk7QW+So/f07xfqS1/Cw244J/d1S9B9L6S7PNwgN+AcR6EwJgfkcuXnOJ0nKEqS3P
 0x5FDJ5U
 z0D3S0nqVKHGasCUfw4fbJXiSqxOJUdxaopW+fAT6IkG+wt2eNqIByim7LaaORbedBJqwLby1/NPTpv6RYI6qjvT0XMhPTjKDYitUkVnl55pQA87E6OxB6hNXOaZdJT1L0fqIUb/MZ4K+vU1mnMIAG+7ZAB8vC8jSoF2cHTl3XUTDVRA629i7Q3cdnKiEg/kicqPTBVC92JHOADb3/7bHFW67Zhgpe8NOhB9ABuvKY9DCo9v4bxR4oimiDACbfzCA1t0Fnowp/t421f4E77VhdwgqFZ92OuKjh1p1SB8uS+Y0CYrh9NyP3NIQpxl03HloOna4QnQvvLIW6nWCUhLqdMBzJcxT8vuqfsV7ygMGrxCm91D1TxnJD/A5B9gF9cNJMqZrS9YxVtUUn1HooEGyvbZ4ddJz/QX+9o/jdZT/kgAn8QPxdVyvyW7bkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--MCBoundary=_12603251136201591
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=UTF-8

__filemap_fdatawait_range() waits for writeback using
folio_wait_writeback(), which sleeps in TASK_UNINTERRUPTIBLE. On network
filesystems (NFS, CIFS, 9P) the server can stall for minutes or hours,
leaving processes in unkillable D-state. The only recovery is a node
reboot.

Replace folio_wait_writeback() with folio_wait_writeback_killable() so
that SIGKILL can interrupt the wait. On fatal signal, release the folio
batch and return early. The writeback itself continues on the server --
only the client-side wait is interrupted. The dying process never
inspects the return value, and other processes get correct error
reporting through errseq_t (mapping->wb_err) which is set by the
writeback completion path independently of this wait.

Additionally, skip the writeback wait entirely when the calling process
has PF_EXITING set. This handles a re-entry trap discovered in testing:
when SIGKILL wakes a process from the killable wait, do_exit() sets
PF_EXITING and then exit_files() closes file descriptors, which on NFS
triggers nfs4_file_flush() -> nfs_wb_all() -> filemap_write_and_wait()
-> __filemap_fdatawait_range(). At that point wants_signal()
(kernel/signal.c) rejects all signals for PF_EXITING tasks -- including
SIGKILL -- because the PF_EXITING check precedes the SIGKILL exception.
The second killable wait would therefore block forever. Checking
PF_EXITING at entry avoids this: the process is dying and has no use for
writeback confirmation.

Signed-off-by: Rushil Patel <rushil.patel@gsacapital.com>
---
 mm/filemap.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 406cef06b684..d348f1dd75f9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -515,6 +515,15 @@ static void __filemap_fdatawait_range(struct address_s=
pace *mapping,
 =09struct folio_batch fbatch;
 =09unsigned nr_folios;
=20
+=09/*
+=09 * If the process is exiting (PF_EXITING), skip the writeback wait.
+=09 * During do_exit(), nfs4_file_flush() re-enters this function, but
+=09 * wants_signal() rejects signals for PF_EXITING tasks so a second
+=09 * SIGKILL cannot wake us from the TASK_KILLABLE wait below.
+=09 */
+=09if (current->flags & PF_EXITING)
+=09=09return;
+
 =09folio_batch_init(&fbatch);
=20
 =09while (index <=3D end) {
@@ -529,7 +538,10 @@ static void __filemap_fdatawait_range(struct address_s=
pace *mapping,
 =09=09for (i =3D 0; i < nr_folios; i++) {
 =09=09=09struct folio *folio =3D fbatch.folios[i];
=20
-=09=09=09folio_wait_writeback(folio);
+=09=09=09if (folio_wait_writeback_killable(folio)) {
+=09=09=09=09folio_batch_release(&fbatch);
+=09=09=09=09return;
+=09=09=09}
 =09=09}
 =09=09folio_batch_release(&fbatch);
 =09=09cond_resched();
--=20
2.47.3

For details of how GSA uses your personal information, please see our Priva=
cy Notice here: https://www.gsacapital.com/privacy-notice=20

This email and any files transmitted with it contain confidential and propr=
ietary information and is solely for the use of the intended recipient.
If you are not the intended recipient please return the email to the sender=
 and delete it from your computer and you must not use, disclose, distribut=
e, copy, print or rely on this email or its contents.
This communication is for informational purposes only.
It is not intended as an offer or solicitation for the purchase or sale of =
any financial instrument or as an official confirmation of any transaction.
Any comments or statements made herein do not necessarily reflect those of =
GSA Capital.
GSA Capital Partners LLP is authorised and regulated by the Financial Condu=
ct Authority and is registered in England and Wales at Stratton House, 5 St=
ratton Street, London W1J 8LA, number OC309261.
GSA Capital Services Limited is registered in England and Wales at the same=
 address, number 5320529.

--MCBoundary=_12603251136201591
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<html><body>__filemap_fdatawait_range() waits for writeback using<BR>
folio_wait_writeback(), which sleeps in TASK_UNINTERRUPTIBLE. On network<BR=
>
filesystems (NFS, CIFS, 9P) the server can stall for minutes or hours,<BR>
leaving processes in unkillable D-state. The only recovery is a node<BR>
reboot.<BR>
<BR>
Replace folio_wait_writeback() with folio_wait_writeback_killable() so<BR>
that SIGKILL can interrupt the wait. On fatal signal, release the folio<BR>
batch and return early. The writeback itself continues on the server --<BR>
only the client-side wait is interrupted. The dying process never<BR>
inspects the return value, and other processes get correct error<BR>
reporting through errseq_t (mapping-&gt;wb_err) which is set by the<BR>
writeback completion path independently of this wait.<BR>
<BR>
Additionally, skip the writeback wait entirely when the calling process<BR>
has PF_EXITING set. This handles a re-entry trap discovered in testing:<BR>
when SIGKILL wakes a process from the killable wait, do_exit() sets<BR>
PF_EXITING and then exit_files() closes file descriptors, which on NFS<BR>
triggers nfs4_file_flush() -&gt; nfs_wb_all() -&gt; filemap_write_and_wait(=
)<BR>
-&gt; __filemap_fdatawait_range(). At that point wants_signal()<BR>
(kernel/signal.c) rejects all signals for PF_EXITING tasks -- including<BR>
SIGKILL -- because the PF_EXITING check precedes the SIGKILL exception.<BR>
The second killable wait would therefore block forever. Checking<BR>
PF_EXITING at entry avoids this: the process is dying and has no use for<BR=
>
writeback confirmation.<BR>
<BR>
Signed-off-by: Rushil Patel &lt;rushil.patel@gsacapital.com&gt;<BR>
---<BR>
 mm/filemap.c | 14 +++++++++++++-<BR>
 1 file changed, 13 insertions(+), 1 deletion(-)<BR>
<BR>
diff --git a/mm/filemap.c b/mm/filemap.c<BR>
index 406cef06b684..d348f1dd75f9 100644<BR>
--- a/mm/filemap.c<BR>
+++ b/mm/filemap.c<BR>
@@ -515,6 +515,15 @@ static void __filemap_fdatawait_range(struct address_s=
pace *mapping,<BR>
 =09struct folio_batch fbatch;<BR>
 =09unsigned nr_folios;<BR>
 <BR>
+=09/*<BR>
+=09 * If the process is exiting (PF_EXITING), skip the writeback wait.<BR>
+=09 * During do_exit(), nfs4_file_flush() re-enters this function, but<BR>
+=09 * wants_signal() rejects signals for PF_EXITING tasks so a second<BR>
+=09 * SIGKILL cannot wake us from the TASK_KILLABLE wait below.<BR>
+=09 */<BR>
+=09if (current-&gt;flags &amp; PF_EXITING)<BR>
+=09=09return;<BR>
+<BR>
 =09folio_batch_init(&amp;fbatch);<BR>
 <BR>
 =09while (index &lt;=3D end) {<BR>
@@ -529,7 +538,10 @@ static void __filemap_fdatawait_range(struct address_s=
pace *mapping,<BR>
 =09=09for (i =3D 0; i &lt; nr_folios; i++) {<BR>
 =09=09=09struct folio *folio =3D fbatch.folios[i];<BR>
 <BR>
-=09=09=09folio_wait_writeback(folio);<BR>
+=09=09=09if (folio_wait_writeback_killable(folio)) {<BR>
+=09=09=09=09folio_batch_release(&amp;fbatch);<BR>
+=09=09=09=09return;<BR>
+=09=09=09}<BR>
 =09=09}<BR>
 =09=09folio_batch_release(&amp;fbatch);<BR>
 =09=09cond_resched();<BR>
-- <BR>
2.47.3<BR>


<hr>
<font face=3D"Arial" color=3D"Gray" size=3D"1">
For details of how GSA uses your personal information, please see our Priva=
cy Notice here: <a href=3D"https://www.gsacapital.com/privacy-notice" targe=
t=3D"_blank">https://www.gsacapital.com/privacy-notice</a>
<br>
<br>
This email and any files transmitted with it contain confidential and propr=
ietary information and is solely for the use of the intended recipient. If =
you are not the intended recipient please return the email to the sender an=
d delete it from your computer and you must not use, disclose, distribute, =
copy, print or rely on this email or its contents. This communication is fo=
r informational purposes only. It is not intended as an offer or solicitati=
on for the purchase or sale of any financial instrument or as an official c=
onfirmation of any transaction. Any comments or statements made herein do n=
ot necessarily reflect those of GSA Capital. GSA Capital Partners LLP is au=
thorised and regulated by the Financial Conduct Authority and is registered=
 in England and Wales at Stratton House, 5 Stratton Street, London W1J 8LA,=
 number OC309261. GSA Capital Services Limited is registered in England and=
 Wales at the same address, number 5320529.<br>
<br></font>
</body></html>

--MCBoundary=_12603251136201591--


