Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C596C5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 15:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA86A6B0095; Sat, 22 Aug 2026 11:23:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59766B009B; Sat, 22 Aug 2026 11:23:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F9B6B009D; Sat, 22 Aug 2026 11:23:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B557A6B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 11:23:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3413B1A0198
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 15:23:24 +0000 (UTC)
X-FDA: 85129274328.01.C2166A2
Received: from relay.hostedemail.com (unirelay04 [10.200.18.67])
	by imf11.hostedemail.com (Postfix) with ESMTP id 70B8A40002
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 15:23:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787412202;
	b=uJzAKk4C4rTdp7UwiikiMbSg4oiE7oVkiQ8qhOuQizj10Szl+LuDlzVx8Dhi2FS0ai9G5B
	+3jYDp+RQXKNXPwb+WEzFYZ0bj8V4sUlk4hGDzrl96Zu7D7oL9PCwGJDorK1yZ/aGuU94p
	k4w3N/6D5Pl9wbLebc/5Hg+Lz9LDPlY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787412202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WrJatvS+dpsgvexrFJw28Fc/KzpHX/g5DZqmk0x10VM=;
	b=HWfexrCDA7f7YL9yncF0SmEYiT1alPG6imZdw2WAjhVp3RPLZbBUHzfIFYEXlqd9+yuGC7
	A04ZIeuwzQmhKksf5V/dehJavb8KGzaSyqwrpCBWPWKLtnsN8YcDpUuawvrUyy+xwV8aQu
	izkl6n6w/RGdzkdoLJJrI1IGc+Pz6pQ=
Received: from omf11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD4DF1A019A;
	Sat, 22 Aug 2026 15:23:20 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id 64C072002C;
	Sat, 22 Aug 2026 15:23:04 +0000 (UTC)
Date: Sat, 22 Aug 2026 11:22:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: =?UTF-8?B?SsOpcsOpbXk=?= Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Cc: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, mgorman@suse.de, include@grrlz.net,
 bsegall@google.com, dietmar.eggemann@arm.com, kees@kernel.org,
 kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 vschneid@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] fork: initialize function graph state before
 copy_exec_state()
Message-ID: <20260822112248.1b7e1b1d@fedora>
In-Reply-To: <20260822084927.547141-2-Jeremy.Jean@oss.cyber.gouv.fr>
References: <20260822084927.547141-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/qlZgXADOrmF5uNiwy2VX4iR+37QC+ua0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=WrJatvS+dpsgvexrFJw28Fc/KzpHX/g5DZqmk0x10VM=; b=LU3Tlu5E9WSgJxSNWsL/2vPXgUhe5EFm0BYPSVPu6drm7C50bC8/L89hVt2/9AlzA+Yks7JGZ4GdAiJkNwrwO2dpI/ms/oa77mR9N7/ygFttYOV0twgNAzf7sEcRDB5BTXcb7D1mr8kHnAzLL8VjlxN1I4eN7aIXBnDAn+TPqXQ=
X-HE-Meta: U2FsdGVkX1/EQPw/mJTjICcbGMkIafRXyWn0hFafPUl7sXG2e1khZHtjupHcjqNglVg48miZ0LvxnwKP5Wd1l2RYRGTOPx0Jhs6zNAfz5mi+0gVIRFydJJBtShVAm6z0N1E5BxBpbu4Fxa64G9l2HoCnbqkZFEeTYbpzcwQitm6cLbzZtiXVeWOkRhdwIq2JeFoKn65Bou4/Zinu6QOwvKmRtTAV+iAeowY+75dy6mrVgL0D4LfRWQpIsjJT3yjIdxMXM5gfZBIPcmGp7e1T8+iDcndX9bZGSvlcE1/wbPHtGj54C0brJr4aYF7RlK21GqpbuskWc+u5qPYHDYasoFUuhVQghrIg
X-Rspamd-Queue-Id: 70B8A40002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Stat-Signature: ajshg4cetoi7kmjm6yugn1ah3akmwne5
X-HE-Tag-Orig: 1787412184-401758
X-HE-Tag: 1787412202-189412
X-HE-Meta: U2FsdGVkX1+RFY7Z+cZ6bwI0ftl1BmNgDbtQEgscghiJCep1rmDch72+WKR8O7cq2fsqaA5xYJvZyEe7rZnBbNBUVJsb9VeDlQS4T2uB3qHrIVXP4NZNmVylh2uw45CnROufnQ9eUZPoQXVwZ61B8lGSwIftwB6cm+KX7utX2I90Lzv42Nqg5vQDOOslh4+dkWEyn3uVfemhiSI+7u9c+2BXqaWs0ggkNV1VMsCozgvrTBf9haZoZFUJWC/d6xMDMuXZK09CasxLT6FatdjJId8Rv8971MZjJRELYEztbn1SIrFlzmIeu27Zt8fOOSv+AeDCvw9E7B90NRgC25wFQ6TeQ9a9L4Q2FA6TwAeMuS+5HJzMTaZ6e3135welYfRoMd6TxhPnB6n5qpxR3qu9erOENwVNiB1wvgOWmGm0E8Wrd5tN1xxEzkAkhoK5cHTVUmF6EIrh84VhXriUcS1NykK6H9/7zElg9uN3koHsNWzCzrmy0FjKC2FPiWVzMuAmH7BhPi30tqlcCNayYDZpL/0GJplhhXrEXjb+wiDOYRP/nDCHMPr08yTBuLKIslAn9Ts62TVDHUrVcg2kZmQKProMlOfECnEK3cTojsQ9u7xE97DykfZ2BEqVl0XIZ+MOgi4q7qJ/fOVU6I6T3Ra6OxwnGGsW5KQXaeP6cb50By5hLnb2/n6UvVbW5dIrPQkn+ff3KLxqUIgb+15N80KWL90GddbvMqnfNJve685EhL+M1a3EjssoTCN9+2UjhSIDY3rMyFeqQQoguZrZb0NWq1lz/AtGcV78bL4q2e/94r4+CXydwwwOUp/UD637jXAYfloDngbawoj47eNq6WYVKUq8R+PgKKkp/zLVlCDOG+RA2xc7DGpmuPy6Sf3O4jepU2oQSQ8kMnxJ59+T7BCud/yi5FgOcSfbzcCiIahgnAh7mMUmN2TIFPrltdaXiA6rU5edFoJpL1F59+S5uvz
 IhHbavAB
 +WLaju6WogxKr18JBQvj9Mn/j/nsiVvW5ubelsY5NuqarG1zKdvXwdu3lmhbRttAd67v5S1xWZXed7/meMnkaHXfQ5Dc840ZwT5IxQwHi4Ngc42D9XRmyPZ8vmUX1Kyg7yKTlMd7T28mvgKXmPhQezHbH763FmhKQdM906bfWp0nUWYRhBn6+tD7R0lQy7pUmyVrnGqwcUfWT0OqF4sZRhW0/wDhDCiP9zF9YaR//btL6BtA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 22 Aug 2026 08:49:27 +0000
J=C3=A9r=C3=A9my Jean <Jeremy.Jean@oss.cyber.gouv.fr> wrote:

> dup_task_struct() copies the parent's task_struct, including ret_stack.
> ftrace_graph_init_task() clears the copied function graph state, but it
> currently runs after copy_exec_state().
>=20
> For non-CLONE_VM forks, copy_exec_state() allocates a new task_exec_state.
> If that allocation fails, copy_process() reaches bad_fork_free and
> free_task() calls ftrace_graph_exit_task(). Since the child still carries
> the parent's ret_stack pointer, the unwind frees the parent's active
> function graph return stack. The parent subsequently accesses freed memory
> from function_graph_enter_regs().
>=20

As this effects function_graph tracing, please resend and Cc:
linux-trace-kernel@vger.kernel.org so that it gets to the proper
patchwork. It will need to go through my tree so that it gets the
proper testing.

Thanks,

-- Steve

