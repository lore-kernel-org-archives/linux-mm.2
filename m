Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92325103A9AD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DC156B008A; Wed, 25 Mar 2026 07:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D5B6B0092; Wed, 25 Mar 2026 07:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2A46B0093; Wed, 25 Mar 2026 07:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 686836B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:36:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 10E93140816
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:36:23 +0000 (UTC)
X-FDA: 84584382246.08.E6AB860
Received: from eu-smtp-delivery-195.mimecast.com (eu-smtp-delivery-195.mimecast.com [185.58.86.195])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3E34D18000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:36:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gsacapital.com header.s=mimecast20170115 header.b=bhZKQAZw;
	spf=pass (imf16.hostedemail.com: domain of rushil.patel@gsacapital.com designates 185.58.86.195 as permitted sender) smtp.mailfrom=rushil.patel@gsacapital.com;
	dmarc=pass (policy=none) header.from=gsacapital.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774438581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bt5JFko0dMhC8KatqhMqVwMjvYD1jEEdorxPfhqMy98=;
	b=Wy5XUUw5Avw8hTxhuURIFerHsdqL63whMw9qJ6SCrLxOuvrhGqQ3HEgdHN47IGI7Vd6SvG
	j3169c8FhfCN1Hqx5easdZd/4tqEzpmyoynreP1YSjeVxdkewZYUzSgxGamg5OdXenMIcb
	OXT/lwKpTcu57O/7EXnEoTk+GhN62UE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774438581; a=rsa-sha256;
	cv=none;
	b=IQ10oa30xlvgRS5QKhTFs5z4ubETw0KH1NAdtyYhA/5tlXcdmgeEeNlbcfWOccZMZMJ6xZ
	GGnjAYIzCU8djPS2OW0P0WXTzvUyxfWXL5Mekno8noNJBCame63A5v94QR4QyFvr6Ud2Lj
	m9gZr5/FOoAZjwAPYqq/AKl2wWhBRpk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gsacapital.com header.s=mimecast20170115 header.b=bhZKQAZw;
	spf=pass (imf16.hostedemail.com: domain of rushil.patel@gsacapital.com designates 185.58.86.195 as permitted sender) smtp.mailfrom=rushil.patel@gsacapital.com;
	dmarc=pass (policy=none) header.from=gsacapital.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gsacapital.com;
	s=mimecast20170115; t=1774438579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=bt5JFko0dMhC8KatqhMqVwMjvYD1jEEdorxPfhqMy98=;
	b=bhZKQAZwC+/kbaVdP5OE2JuCsYukl24Ik04kf/eQW09KQP/xUe1gUBwTAP5lRv9SdF58NK
	abuLLfMxIJykpNiYAQw/LLeu1mv1i+ajhtN9R94Ku3MCDZXqX8KA3vOsON8QAMRHJ0386s
	3EsZJtbSzVd84FcpUlejGaSRXJkZyJc=
Received: from mailrelay.gsacapital.com (185.137.2.10 [185.137.2.10]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id uk-mta-247-45vwAdfFO6SopuH8bJ86qg-1; Wed,
 25 Mar 2026 11:36:18 +0000
X-MC-Unique: 45vwAdfFO6SopuH8bJ86qg-1
X-Mimecast-MFC-AGG-ID: 45vwAdfFO6SopuH8bJ86qg_1774438578
From: Rushil Patel <rushil.patel@gsacapital.com>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Rushil Patel <rushil.patel@gsacapital.com>
Subject: [RFC PATCH 0/1] mm/filemap: make writeback wait killable in __filemap_fdatawait_range()
Date: Wed, 25 Mar 2026 11:36:15 +0000
Message-ID: <20260325113616.785496-1-rushil.patel@gsacapital.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wR0_MZMU_4zvap-0EQqqvqLkvKqvyKqIgSQYBmsOQfs_1774438578
X-Mimecast-Originator: gsacapital.com
Content-Type: multipart/alternative;
	boundary="MCBoundary=_12603251136190191"
X-Rspamd-Queue-Id: 3E34D18000B
X-Stat-Signature: 7y5dpb15tee4t4cgd55j7qqwzxizhsj7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774438580-129591
X-HE-Meta: U2FsdGVkX1/ONs3k2XAf9RLoWU+FwBrxOyGD69wq6BiQ94ecGTdhev4S/II6Sqv5pNfQfrit/OdoLbOCNWJe2d9pGXKlOD6Kwp7VwsLh2f6q6/oLLDjl88wIp2Oc0AlIAMpqyPMRFfVS8N9eFKRD6v2fEQMBoTFFyRy93/DkbW3Fr2fvtfXYc4i/5n/no5HMR8yQ7ADVbj8dHcAKnQa1jfECG20QFfBUHPZ+GWethmspCXWy8OUigyHIyuvwTWDforWto0REMv9wedj/OE2WuJ6dG62w2Rx6if6KF9hnwI8l4zOlFe3Su7/DlDvsFcESnpRTYvi59+SfGBA3KuniLiDdtldfAXPb5ow7uDtZtXUBW/TuA6fkSw+MwODnTpZI7xCpiUVEyXyJ/1PWyHTp/nuJfACVA98uNpuXwyrgo5Ud4KpR4dInPPpnIpHriSdRY/paeLO5K9/jINS9pWprgUjfeYCgJZHTYD+IVKzHGFVMtq10JxbGNNQRLfWIBtZx+TZmu6s27NOn27ADu/929I29oEFKzleykEC51A2cwV/JZ4FZQorm6c+677EP/ZJOktKOnuBJePCYDCZIaZeHhwHHnXdw6Pq0R3NgG16U671WOgD/jWHjvR/nplpLnchQFQ8NgYHFy8I1pCscbw83CJW/XBylonzgp7HU00NoDaQMxoZQpVQfNVxJ8vlz6qUfWEgGfpNuimaxHyC2JDl4nNG0omhLcPhzguB69egmOK+diHqbv//D0skw3PlhMvbYOSr3ZA2RHQHsh7eLn1xUCAwQKx1MkbvZyf8RKrldZNV+lsGlfYfZzNriIdNvywB5JbPQbkzYutVB3Ip3EjHxcSAX2wa2/11+aXCqo6e/kGXv0kJivr0jeI538bs/rO4OU2bFdH/46qJoWEGKV12FUh8qpcLk8zdTF8rxrPgPd6Rf2c+RzOesdVyYsAqkBqhR1Ls8kDn5pgUIw/W6DeS
 rRH0xoFT
 pgYmPyaF/Of14LTg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--MCBoundary=_12603251136190191
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=UTF-8

We run Slurm on compute nodes with NFS mounts (NFSv4.1, NetApp).
When a job is cancelled, processes with dirty NFS pages get stuck
in D-state inside folio_wait_bit_common() because
__filemap_fdatawait_range() uses folio_wait_writeback(), which is
TASK_UNINTERRUPTIBLE. If the filer is slow to respond these processes are
unkillable - we've found the only recovery in practice is rebooting
the node.

The patch switches to folio_wait_writeback_killable() so SIGKILL can
interrupt the wait. Writeback itself continues on the server, we just stop
waiting for the ack. All 6 callers of __filemap_fdatawait_range() detect
errors independently via errseq_t / filemap_check_errors(), so the early
return doesn't suppress error reporting.

The tricky part is a re-entry through do_exit(). Making the wait killable
alone isn't enough - we hit this in testing:

  1. SIGKILL wakes the killable wait, signal is consumed by get_signal()
  2. do_exit() -> exit_signals() sets PF_EXITING
  3. do_exit() -> exit_files() -> nfs4_file_flush() -> nfs_wb_all()
     re-enters __filemap_fdatawait_range()
  4. wants_signal() checks PF_EXITING *before* the SIGKILL special case
     (kernel/signal.c:951 vs 954), so it returns false
  5. No signal can wake the second wait -> stuck in D-state again

The PF_EXITING check at the top of the function avoids re-entering the
wait entirely. This is the same pattern used in mm/oom_kill.c,
mm/memcontrol.c, block/blk-ioc.c, and io_uring/.

Reproduced with iptables DROP on port 2049, confirmed the killable-only
revision gets stuck on re-entry, and the PF_EXITING + killable revision
kills cleanly.

Sending as RFC because this touches the generic writeback sync path in
mm/filemap.c rather than being NFS-specific. NFS can't really fix this on
its own - it reaches __filemap_fdatawait_range() through
filemap_write_and_wait() and doesn't own the wait. But I wanted to get
guidance on whether this is the right place for the fix, or if you'd prefer
a different approach.

Best regards,

Rushil

Rushil Patel (1):
  mm/filemap: make writeback wait killable in
    __filemap_fdatawait_range()

 mm/filemap.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

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

--MCBoundary=_12603251136190191
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset=UTF-8

<html><body>We run Slurm on compute nodes with NFS mounts (NFSv4.1, NetApp)=
.<BR>
When a job is cancelled, processes with dirty NFS pages get stuck<BR>
in D-state inside folio_wait_bit_common() because<BR>
__filemap_fdatawait_range() uses folio_wait_writeback(), which is<BR>
TASK_UNINTERRUPTIBLE. If the filer is slow to respond these processes are<B=
R>
unkillable - we've found the only recovery in practice is rebooting<BR>
the node.<BR>
<BR>
The patch switches to folio_wait_writeback_killable() so SIGKILL can<BR>
interrupt the wait. Writeback itself continues on the server, we just stop<=
BR>
waiting for the ack. All 6 callers of __filemap_fdatawait_range() detect<BR=
>
errors independently via errseq_t / filemap_check_errors(), so the early<BR=
>
return doesn't suppress error reporting.<BR>
<BR>
The tricky part is a re-entry through do_exit(). Making the wait killable<B=
R>
alone isn't enough - we hit this in testing:<BR>
<BR>
  1. SIGKILL wakes the killable wait, signal is consumed by get_signal()<BR=
>
  2. do_exit() -&gt; exit_signals() sets PF_EXITING<BR>
  3. do_exit() -&gt; exit_files() -&gt; nfs4_file_flush() -&gt; nfs_wb_all(=
)<BR>
     re-enters __filemap_fdatawait_range()<BR>
  4. wants_signal() checks PF_EXITING *before* the SIGKILL special case<BR>
     (kernel/signal.c:951 vs 954), so it returns false<BR>
  5. No signal can wake the second wait -&gt; stuck in D-state again<BR>
<BR>
The PF_EXITING check at the top of the function avoids re-entering the<BR>
wait entirely. This is the same pattern used in mm/oom_kill.c,<BR>
mm/memcontrol.c, block/blk-ioc.c, and io_uring/.<BR>
<BR>
Reproduced with iptables DROP on port 2049, confirmed the killable-only<BR>
revision gets stuck on re-entry, and the PF_EXITING + killable revision<BR>
kills cleanly.<BR>
<BR>
Sending as RFC because this touches the generic writeback sync path in<BR>
mm/filemap.c rather than being NFS-specific. NFS can't really fix this on<B=
R>
its own - it reaches __filemap_fdatawait_range() through<BR>
filemap_write_and_wait() and doesn't own the wait. But I wanted to get<BR>
guidance on whether this is the right place for the fix, or if you'd prefer=
<BR>
a different approach.<BR>
<BR>
Best regards,<BR>
<BR>
Rushil<BR>
<BR>
Rushil Patel (1):<BR>
  mm/filemap: make writeback wait killable in<BR>
    __filemap_fdatawait_range()<BR>
<BR>
 mm/filemap.c | 14 +++++++++++++-<BR>
 1 file changed, 13 insertions(+), 1 deletion(-)<BR>
<BR>
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

--MCBoundary=_12603251136190191--


