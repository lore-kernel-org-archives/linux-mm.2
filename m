Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D96B2606A33D
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NVtZrvpj
Received: by kanga.kvack.org (Postfix)
	id 094706B00EF; Mon,  9 Nov 2026 13:01:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044BA6B05B0; Mon,  9 Nov 2026 13:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9C956B05B9; Mon,  9 Nov 2026 13:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C95176B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:01:16 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 62FC41C4164
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:01:16 +0000 (UTC)
X-FDA: 85416347352.10.9ED1D75
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 31A7840007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:01:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NVtZrvpj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794247274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqQObdUpHHYtUe+LeCHrZ/2wo3MZK4ZISN3fNU+Q+88=;
	b=sFyNnVqeyxDgxhWJp+1wObjOvfDn3WaY/sBF8SvnZEq67W85zudVlfezx2vlI8b8F7+Pun
	QP5go2r3my360OzbhGso7FlAvlROCvTspDddaXqPtSC3fcF/s7uoluWoodvu/nPtOAI5+5
	SyzajWFdJHbuDME0+Ap6f8cGHRTrdLU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NVtZrvpj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794247274;
	b=kjjFpbL/NwtleAvKQgbhXhL78fHWhn+awrSHTS/QlZRH4UqhFPpvJobiejI/i2/p7pXrFf
	y3kR9qJAFofcHNC4Desunpop2g7q6wL3w8T6WYhc2iiabEIzx3fmk7AvWlF8P70dvDvL/K
	KXK7cdkRpz7WzkE/kbTHNlr7GKxCI3M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794247273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uqQObdUpHHYtUe+LeCHrZ/2wo3MZK4ZISN3fNU+Q+88=;
	b=NVtZrvpjCoL5u3yK1KQIcQVu2UM4tChcy5f++P3HTGys/mmWt0rzZueerdMtn2N/2G8WG8
	5H/dFVv+lTUJbYv4vjk2gQTYSLuDwabT0eqBARptFaXTqjoEpPKp9BDLJHJXaM6NppCtxB
	dZXpxc28Dp7OgPM53ee3MC8HxGxtSTc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-43-Q-0kTqdZPtqltUwQp3l6_g-1; Mon,
 09 Nov 2026 13:01:09 -0500
X-MC-Unique: Q-0kTqdZPtqltUwQp3l6_g-1
X-Mimecast-MFC-AGG-ID: Q-0kTqdZPtqltUwQp3l6_g_1794247265
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 179B1180075A;
	Mon,  9 Nov 2026 18:01:03 +0000 (UTC)
Received: from onestero-thinkpadp1gen7.tpbc.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 71C211956087;
	Mon,  9 Nov 2026 18:00:52 +0000 (UTC)
Received: by onestero-thinkpadp1gen7.tpbc.csb (nbSMTP-1.00) for uid 13628
	oleg@redhat.com; Mon,  9 Nov 2026 19:01:02 +0100 (CET)
Date: Mon, 9 Nov 2026 19:00:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: kees@kernel.org, akpm@linux-foundation.org, david@kernel.org,
	Jinjie Ruan <ruanjinjie@huawei.com>, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, mingo@redhat.com,
	peterz@infradead.org, juri.lelli@redhat.com,
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
	rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com, paul@paul-moore.com,
	jmorris@namei.org, shuah@kernel.org, brauner@kernel.org,
	alexjlzheng@tencent.com, jannh@google.com, jaime.saguillo@gmail.com,
	elver@google.com, blbllhy@gmail.com, bvanassche@acm.org,
	pjw@kernel.org, broonie@kernel.org, debug@rivosinc.com,
	tglx@kernel.org, aleksey.oladko@virtuozzo.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, morgan@kernel.org
Subject: Re: [RFC PATCH v2 2/3] security: Add PR_CAPBSET_DROP_MASK for
 process-wide bounding-set drops
Message-ID: <avIKUzCKAkfC-wuk@redhat.com>
References: <20260929130200.1638343-1-ruanjinjie@huawei.com>
 <20260929130200.1638343-3-ruanjinjie@huawei.com>
 <atjN3JX7sWx9kpQ5@hallyn.com>
 <avHfm5/mVtuN/oPW@hallyn.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <avHfm5/mVtuN/oPW@hallyn.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: pBWOwIp3uLNtwBMM_vjzuDcHlE6F1zv5dS9EvdGGau8_1794247265
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 31A7840007
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: hrsoojaa7joyxnk4n4buwo1j8eob7qg1
X-HE-Tag: 1794247274-561426
X-HE-Meta: U2FsdGVkX19yKFPHx1HeTr5ZvnjwCFpDQKPR40QzgTbtdItaSMld87IeO45+Q+bQ+JdQTwbx8EYaheXXa77fG0aO0kXSjYz5GIAtFXN/+8+e59J9emio/o7lnMrpCwoogdyq7moQohBGP+9x/i+E/ZZZ81OeLd5LHsEhjoJt8n6cIV/y74VawYp8CiZArJ1ltwRLcYXac1G+vEyyybMRXqE+/iQYZ6ZolRzRse9YvPfsEoBM7Wjod9WVcaGIs4/lNUp/NWHCBZNhWE4uxH2O6j/xsHQtT4U4qz7bLf2QrJyxfbK1AnbfdKeCw/UU7Njwrz6NYveodFWqCQ/qmOWR951GzFlD+MEbPIsgQonnd0UMBcbUDL0oubJeHqbKazuQr3aQOH564nkZARzD02qX7DmHSfL0o946fpR+0+fgH64zE3RCBr7dDDVfQs/xq1Qq8Y1M9oJpjdfEmkvxHSVw0k0FS2kLXvKtkkiY7dQWvCrJ1k8wmwanQ3We58+aS3fZ4V6cm7cYA6gYf7FLkFVz8bexPRVb7+EyOid7dIqn9bOnebcuMoCtTz2lWlZLrar6IjjIlSONX1PN5xSj8+YxidXBf3qgbWa5Sfh7/HG1FyUrczgG9q9ySkciaPYepacSQSxC3/YCM2F/MoxLtLgQkCZKhbxgQv+D+A61dWeAyk+8TpCqTkii1Wn2a5Ed5i0cl9yOynkgGmo3rXtk6Q7iarxIpcrVihzzOM2MpfxTqEjkhN8QMbqW66Z1lewtqu+qEt0miaUMCdDfRLZGhc8EX1P4xyrAyXsnu0GLAXXoHTf1uyeQ5l9nP3VDRonacO30I9O0PAS6JRtWycjLUTT3UGBVSFHHeAse/dOzhc058CE0BMnERfLckrS2c52R641hJ0x1XTjviECcucxHWYRfEWPSHRAdp3xoXhpNH7HeYvoiqIKI/iOCHWVB4fONmUunuy2V4xvyvPjlpAaWWOJ
 JLaLznbA
 Um/xv53C7A6qEyXEcDUPpeL16EK6zFhn/wHf1fUBBCUh5bKbHTUwMTTT6L8GqTzxP65G0vHChE6vZhD3WCfqorLSZymJ6nTK0w312mb1KPRPYOxj1WTgMI87nG888PvQj6WeNwIargtfVGdh+GB+wKX0udWBJagCRgnsqv+TEphHk2chAj53TG0fOaZTjVxpm77sHvbFr5mDiQ8J5hlU0h3GdFKwBrOh8LQAf/GquLiCRq3fD4Ht6Tc8vVaG7SaW1cjDJh71GLycBWrPxfR8y9mgxOvxx7jIvZS/ocp5V/kDOnkMJpRtvxxNyOsq+7ZFac2JnMX9acalvS2XE5ymqdjZUAnPx19hC1hajiwf9/GO3OhgrKTfenn0OySb4+JyNMNttaAWTBmUCz51ojMSRNgXGuvjnqzcPV8wGsjeNXc7F0Ie1uyCbnDnIu3tpr9eHCr2yetpg3C924+CXWOut1kU3Ux7XPtUF+Zasd7nL6vvO5W5L3t8rw4+drw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/09, Serge E. Hallyn wrote:
>
> Hi Oleg,
>
> please see below.  Do you have any issues with this use of sighand?

Hi Serge,

I already tried to look at this patch, but sorry, can't really comment.

I'll try to take another look, but can't promise much, I don't understand
the problem space (I could never reallly understand capabilites in details).

Oleg.


