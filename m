Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96E8FCD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50A16B008C; Mon, 25 May 2026 12:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28026B0093; Mon, 25 May 2026 12:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3E576B0095; Mon, 25 May 2026 12:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5AD26B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:27:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8041E1A0184
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:27:45 +0000 (UTC)
X-FDA: 84806473290.14.8E8BD78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D9F2818000C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:27:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fDqfQFCb;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779726463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HsdW9LaIbycHjvJhgWJNxPtg5fqLkG+dKkTc85kX3Yc=;
	b=qrUtE3HVEZx9NumQ+K8oEivOE+UUMnXbbQpqBsmPsahPat21IKPbbuaXuq9V5v8JlwuQP0
	dqbb3QY14OxpfP2UMaS1QfBTxR2tFwBbgS4swqkwGvduF6GMKijWRxR2oPxyayE3CVTh3G
	mmdbXZPfnoZjEksKlg3O1uKWbE5ASRE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fDqfQFCb;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779726463; a=rsa-sha256;
	cv=none;
	b=1BwogxQRukf6jxoqvjFHfAHsXzOr19n1ft9Au+fnz1BdQkgLHORqeT0wszAskOUdF5G8+o
	e2jk8GWK0pJk84zCg0oShN7t4T8Z+wpgrvqV4cs8kZy0ZqR8LwAKoemWQOTyEGg0Zz21pZ
	Wx69M6npfKmdblHDzGfN0dNz2DHSIL4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5963F6008A;
	Mon, 25 May 2026 16:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A325C1F000E9;
	Mon, 25 May 2026 16:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779726463;
	bh=HsdW9LaIbycHjvJhgWJNxPtg5fqLkG+dKkTc85kX3Yc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=fDqfQFCb+eYFk9xywS6U4h2pRlFR0jCbXLZUn6U4B4boj4uEg4X+4Fw08pozOuqAm
	 5uMrvrvD7eSQZgh715hfz8YP22Ed6d8DdlB8VArKNPEeCWBK1+l+XNrhxxMwVbWgE2
	 AYwYlcPS7UhlgWlXE3dM/JcMa5rJ4bw1SG7eEybeuQiwPY5xZV7xNo/dOiX3MmhOUV
	 1W4FzU0kU2rlKRdhiifFG8Z7USHLqq3jxqyJe5KWiYkfBPbWMBKRxZiKdW1oiqbdy2
	 KI4ojdsWS848YFWYatTjKp+lVhO36l5hEUI3uLlB5k8Sp0vN5CeYhgfRc0+Gm5V/Sh
	 TVa5FYTXpNitw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  corbet@lwn.net,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH v2 03/10] liveupdate: Extract
 luo_session_deserialize_one helper
In-Reply-To: <20260514222628.931312-4-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Thu, 14 May 2026 22:26:21 +0000")
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
	<20260514222628.931312-4-pasha.tatashin@soleen.com>
Date: Mon, 25 May 2026 18:27:39 +0200
Message-ID: <2vxzy0h75u9w.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: tdbnx8u1hdark9dcat3rwxdwt8eh9sx5
X-Rspamd-Queue-Id: D9F2818000C
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779726463-52618
X-HE-Meta: U2FsdGVkX181uNXYvw8KHBP6Y5Q/B+bOInE3GL1xOjtZAas8KdzW+FDMhg4IkRSrWtmNigo048ZW6WS1yO265w/u98B/HKTd2CGXqkoKRqulUXlXmg7elp91cTLESyf00eYTPas4rHrtuR419aqwO8MRZOs6yQURY9JYAE2DOllM7R0l4v4KPXH/uBDiM8Ql9OP03BmLJ7murd2kXS2LOCFhocnd0CUWWWcwBphfaRlYeAWwxED3HR0fmdNOvtlER9mjziqKHO5uvEBzmKZPXaLRVaa1ZNtxkQRwRGdAldSFDCTxnqDdaJ7AGcV6F8YBgfMqN4gLFGBydTzh5WdgFxFwCGE/u2IF8Rj4QLv8ob3H9u1GAEoFne6rn2kOUpo5fFYwoCtoemRUk8vsctIquaF+PddhZMCFvLIA0yS5b54UNKVtYHuAfy8NazZgYpD92MV8R2RB0QxGzkhnNvpDLLS925Bv8rRB+gMWTf7CU0f+iVh41AOe2aqoQACj+NFrNQ9W2ozNXBl+qDldudFlnXjN1BwZ0OeD04cZ7goVNq1wHtbG74A+uZdqW0OgNCBX8tsWkri1aFyp6G9caV2tQDBq9r1D2M4AAqGahD1CIpU+crRK/ERnrPnzpZcNw62X9/E4OQIPwfGWRTqa0a0p1YGiCxIsD/fHKH3aXrTiSiyYM0zPfX390kMA1nKQksSRo1f6xPajzk03giClEA3cXrRiQ6REEr8U1dUb9XeHhlO2JkKAXmkn7YeoIBSojCq5NqOMXFYqcs1j2FAdOtbXU6hVrQFaXtx6FwaRamMwLzPIBc9iA90gzhh53l356dUIhqo3iNopp7OcH2bbY1cTXh6qh+KaldTJePTsTON6/r2tDAbDjodBG8BLFaovjJO5KTzgLXxicsFplUqRnx9QqktP6x9MdcwtogBqkml7An4zNEAJtaG3SxF1eSvwrjyBJBH+L7YWxF90TC1k9fc
 JOBDS6Yv
 rRfoIx6SsBTClSrWnWhpBoWV7SNrOy2GCRtAj1sI8+1L7qJVgfqpI7ISjtQplCF/pSkfRvH7UZGsujkSuU40IaAgkmr2QsIVa4ifOlUbuJXlcSBX16hOxy0PZ3eI97R1FgPU34jJM5HAiZbSyJrd1Ee+0kgwWP7EjpkEA3XfEMFidb56cAXZM46To0CZNrreObgqEGXE55B84BILoESxWd3deJoLOd+Z78COnZmLsCvbkwiwueZtyUj+t+NSRWci3mobY/AY7+UReyGz1gYSN+2BxD66OJ/Z+EajWQcOl1+SrDlA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14 2026, Pasha Tatashin wrote:

> Extract the logic for deserializing single entries for sessions into
> separate helper functions. In preparation to a linked-block
> serialization for sessions.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

-- 
Regards,
Pratyush Yadav

