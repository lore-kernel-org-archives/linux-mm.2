Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5019FFD8775
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 13:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CBB06B0005; Tue, 17 Mar 2026 09:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C0F6B0088; Tue, 17 Mar 2026 09:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692546B008A; Tue, 17 Mar 2026 09:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 58D4A6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:58:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E77981601B5
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:58:32 +0000 (UTC)
X-FDA: 84555710064.23.1237EE4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 79C8340007
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:58:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LB+FXGXa;
	spf=pass (imf01.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773755911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CjnQmRkU/l3UkgRwp+/DaDM7NsRFp28HdJQYirkFQAo=;
	b=JlhJrrQ+EYMSXXRjtY5sM7awN31KD9S/u/lc9E1sZ/AuOtQuM18gWqVTxmKRiV8yghsklb
	tr1qDxf2WzzefvAQQLfXvOmxTRsdohkh7/jKKfxpnqjpDVip0Jzl3hxRtC7ruaZpP1p1ZK
	laVV7n5a/kc0B+6imQ88nPGgDMX+rxU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773755911; a=rsa-sha256;
	cv=none;
	b=4koNcFST1pI+Y4uh6Bzs5WUyXnfNaoLin0A2FmyNgXHdKVAVYFiiG1Tp8k8iAAdhRHxZBh
	XPRENTTpcNRmcTxj9NnFZxkKFnAD0MqmouoTz45iIb14JpqlgP0zXKZj9tR5dCTOuZgEJs
	fLknfz9T+1DD2WhngsJUsWf6Xql1Xjw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LB+FXGXa;
	spf=pass (imf01.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773755908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CjnQmRkU/l3UkgRwp+/DaDM7NsRFp28HdJQYirkFQAo=;
	b=LB+FXGXaHrnE2yNpNmqOzUMGm4neQlsRwtysg5rbj/hP6MOYHY3wqZ5wjsdqy1mCBp9+/N
	kODayPdBL2pE76dg2PkZrDuaGoqdyNww1RwjCf6bLV0LwAvqCtkMi9hasF1zpdUtBEqZIg
	lEcdZgkxzDrHmDVJpy9McU6No6Eh9YU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-fBy6XB6YM-C6LUV4Vt7LRg-1; Tue,
 17 Mar 2026 09:58:23 -0400
X-MC-Unique: fBy6XB6YM-C6LUV4Vt7LRg-1
X-Mimecast-MFC-AGG-ID: fBy6XB6YM-C6LUV4Vt7LRg_1773755902
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E8A2A1800245;
	Tue, 17 Mar 2026 13:58:21 +0000 (UTC)
Received: from fedora (unknown [10.45.225.204])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 2742219560B1;
	Tue, 17 Mar 2026 13:58:19 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 17 Mar 2026 14:58:21 +0100 (CET)
Date: Tue, 17 Mar 2026 14:58:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Deepanshu Kartikey <kartikey406@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH -mm v2] do_notify_parent: sanitize the valid_signal() checks
Message-ID: <abld-ilvMEZ7VgMw@redhat.com>
References: <20260316151956.563558-1-kartikey406@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20260316151956.563558-1-kartikey406@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: irMgn3AXeQn-mO02F4KEHrzwU1O8aCp0eAHz7lWxZm8_1773755902
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ug5xwenbtin39h99dix8955q4fd1brbe
X-Rspam-User: 
X-Rspamd-Queue-Id: 79C8340007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773755909-648553
X-HE-Meta: U2FsdGVkX19X6r2po2ryBB1V9MoCWWcfASUJuBscz3/eXX3vmfyMk1CgToukhULD5XHJJFe/EG5QVMxhc0MWfCzzV6gb2mC962X8IIfY9ALvo3A29ie+jIoRw90eeyKuwfQgGb12gEDfzto2dk/jbvq139LbzMFya/WqhxylhcrGP1pfOxaXnkOmO3brw2apKQV57FvocW8WnWL0wOMOZzUdsMbyI3EFhS/EZkZFB5YWQdBIKBoa/ueHkzHlRjhKZ72Vdk7mVGxRsK1hLW4c1vSExTHgMTQmNubJaN/wbv9sz1Fwlf4+0gKoLgpERe2p7KjFwTvUJXTWLqCfo60pSpk8mafVtzrrACO81WK23NCVmaFMp0VpDd9a7JGMP3zADGRvXxIXuoZXGKG13Vk8z0NfO28at9X/oQ9P7+y3Fc0Nm6mMqfjy1T+3RIBXPhCcFllQ6Cz1mlZbvZ5dLGdazPhS+u4L1pyf6VQbOmJKH8M2EG77gFz8lUdvMhKABZcEB0xl3e9Nw5msRMviuMLWvvRPrwqp5pzIhHnzeIGkaaIndCwdxKm1pIzpm/XpwD5OFrli9Ojn3j3velie0UoJUNBoe2b7OlDynF7k6CX7yhn/oWnNp1Nt4SZiCbLD4PwQUDSsGxzh3TCSPhEuydGNxgRqXTFy53gc2k12yE33IbMq7B2Ksy2DOmasyjL4WDTn17iV+ZdCge1el9gXHTo7kUUvCNzJwiGzLJEjnRiOneI+2orBGx8IVx+xo+9MI08QC7g9Fd2pftQeP0M//f4jgQsoCkotHgA/VUIVjjlGIEdI2xnM8+5NCsl+VMqdK/lyuM7BhesAsirsi7WhxzIHXWPULt/p7hPGxj7MUUkoABHlrSsT8lAiBcW0FD3p33MbqGUNU6KNkroopGkbJZhICddX3ZfjUKesaU8nbnyIbGzQy6FnBIp7URZD3zrib6+ucP76XQ2zCXZuCaZGTpr
 7+7X2Ker
 fFDOXItIet4NaM1iCsUONqIJr7E65WmQR41qOPhLIMSU7LMNVkdZkLyNYPiu7M2Q4NoXIMoXn1qZyVdibwMNdIds3ZxLcnQrHklgRMLeVQQg+l5ieIprNkKm7jjyNjzYt3QgPu/4NMMTMrUeiXlpuIndaesTqMaS6Eua1zTNiWiXwIoORP/jlHCxQ9wi3yb9+fYJpEorNhLXICf+jE4q6aeJL6p3kwHL3N0CViX8hAu/NRZYq7tT85lJOPpe8hWOUz/HAnNHJBxvvsxO1fvLqBjJ23OgyRixLHg/dB60E3t+lD2w494x4rNPblGO0J39bOzG7KHadKdx50JojVRol6i/s1T/9Y82zfichIvruPo8M+hobLjhq46Fya0fXLgenPBq+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that kernel_clone() checks valid_signal(args->exit_signal), the "sig"
argument of do_notify_parent() must always be valid or we have a bug.

However, do_notify_parent() only checks that sig != -1 at the start, then
it does another valid_signal() check before __send_signal_locked().

This is confusing. Change do_notify_parent() to WARN and return early if
valid_signal(sig) is false.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 86aad7badb9a..683ef92f7234 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2171,7 +2171,8 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	bool autoreap = false;
 	u64 utime, stime;
 
-	WARN_ON_ONCE(sig == -1);
+	if (WARN_ON_ONCE(!valid_signal(sig)))
+		return false;
 
 	/* do_notify_parent_cldstop should have been called instead.  */
 	WARN_ON_ONCE(task_is_stopped_or_traced(tsk));
@@ -2252,7 +2253,7 @@ bool do_notify_parent(struct task_struct *tsk, int sig)
 	 * Send with __send_signal as si_pid and si_uid are in the
 	 * parent's namespaces.
 	 */
-	if (valid_signal(sig) && sig)
+	if (sig)
 		__send_signal_locked(sig, &info, tsk->parent, PIDTYPE_TGID, false);
 	__wake_up_parent(tsk, tsk->parent);
 	spin_unlock_irqrestore(&psig->siglock, flags);
-- 
2.52.0



