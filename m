Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A22C2606A332
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20260707.gappssmtp.com header.i=@amacapital-net.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hDevG5h2
Received: by kanga.kvack.org (Postfix)
	id C35656B05B1; Wed, 18 Nov 2026 11:59:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE6466B05B3; Wed, 18 Nov 2026 11:59:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87E56B05B4; Wed, 18 Nov 2026 11:59:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B35E6B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:59:57 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA7071207D9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:59:56 +0000 (UTC)
X-FDA: 85448851992.17.B3D2D7C
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id B91351C000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:59:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=hDevG5h2;
	spf=pass (imf21.hostedemail.com: domain of luto@amacapital.net designates 209.85.208.176 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795021194;
	b=yHOj9LuhPcBH2v2HF5ueK7v8mGKL82d6RVrl0QWMVfzy7sZtcFPZcd23OHlxe1VooJI/My
	XgjVHWT58rsdDKaU0LulL5Fkm9qTYZgcEqf+rjajg21mgyvZzmmW9bG4QrxVCI/CFOXSbP
	Mf2cJ895VVhTQOdVyxTzragZZuvGa/k=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amacapital-net.20260707.gappssmtp.com header.s=20260707 header.b=hDevG5h2;
	spf=pass (imf21.hostedemail.com: domain of luto@amacapital.net designates 209.85.208.176 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+eo4FKNzNbHf/eH43g1C8Z3to6Do7+2E27gt4uDxW08=;
	b=2Zjrshr8zp2jmAW5ch/lqiOXC2nSgoCSIOAFgtapq0R3wtE4dxRsgBuc+2Hn7P0BzVwdFF
	2JZwjJbhszPCHHkzTrRlt532yryyTGMLZSjDPmIwml7cn5Wrd59btPCOZgQ1uJZf6YbdBt
	AJsy4U73/6qy5EBXCb7ehyoLtdyRiFE=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3ae2ab35d82so11290721fa.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:59:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795021192; cv=none;
        d=google.com; s=arc-20260327;
        b=YNndI1D1Ti5g81+6ykjFexABUHWerBXMi7ZjPHTMY6y/XyLRsS/8yRjuw+0Y9+BDXx
         HawT4HMeHlCdgFEazvYjPScS4cyF21nH89hoaZyoSWTujtiHSZP5jLcSYLt56xBmEJ1V
         H3/V7TCuukVlpbFjBsXlknt9DV4l+tIL9w+QqNCNhwsCh0gF2ueuf0Z5AfTsmidC7jxF
         jFRW/aA1jssS+LZufLN6CHqNP0XoRtl0bCXBMeOfw7Bz/dPhZpySPJgiCuYLctPioObM
         PoBtch7iHgDm7PQXtp6EmKhzUYRQChY8fqQJ4eqZskbYmytHEcnHqpC+PUX9VLoo2PgT
         i/zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+eo4FKNzNbHf/eH43g1C8Z3to6Do7+2E27gt4uDxW08=;
        fh=Kcfsh3L232R2VpLhYqLFuCN0/COhPLAn+4pRcUQkOEQ=;
        b=Leg57FRn6yH25XmZi2cwIpndu92IK0/exx/vQq9LwBafVSySEJlL8fd4tZ24++BEcX
         c8HE611jsnGRLgN3Iqqg3+jTkZMlhVeT0EoDV+bGnQwqVGPEICp01eptIVb2oqX4h/FE
         yVexKQ2aCdqyBqy8fAp13r6WTOHwCB0fABCGeSvhvDNa23C70Dy2tc+0nuIDCn0ejoOT
         U+6J+3z+Ew4wuT+5bpX5yOkOYgVgD85EKo501Dfr+HdmJmcJT2DuAX8zgJtjlgBjxaIS
         r0Nj4S2Sm8qtfLWzP1gnglUlHpA8k+mnU6N1TJCqNgmCtu4PmlSw2gVkk5kzBue579pC
         kYnQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20260707.gappssmtp.com; s=20260707; t=1795021192; x=1795625992; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+eo4FKNzNbHf/eH43g1C8Z3to6Do7+2E27gt4uDxW08=;
        b=hDevG5h2aXDqqQ6sDNwSJqt4IEKAannun5twElTK2G3VB50xWx2jTYoI5VMPRnteFK
         Yz/HI2Db3OMcvExZVHsnXL9SpId+2zV649Art2DKFeUMNZSm7sQd6/mn9Z9hTX5dahAk
         P+PwfoT02D3ujItN8lCLIinojNgYt5ip45Fi0O7c8RVgMQRtbx15G8k1Wh/KPD+9BxjG
         TCQtGyF/Lel5FEaqR2cyyYMmnPFv6bg9P4gk9EXXfmRCwc7RDBXiRQhvN3QxzVQz4Sch
         wmblDg2gnhSBJRrJDGONcsv+NQVfqWDrXVXx0VATg/6wQcRNjxRZr/UzxK3RKT5WzcfX
         eENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021192; x=1795625992;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+eo4FKNzNbHf/eH43g1C8Z3to6Do7+2E27gt4uDxW08=;
        b=yyZEeDu26jPDLK4gwlR3NT0uG4S4XxrWJIaTyX+ByO/F89H+j261Ljm8eIyNHh+WfK
         Igh3Tge7kfjhAV3ZEPOWtJL8sSP2JbYEgoOHIFxeoRVjbzfpdr/ptallaYqZcdbeJwOd
         1k4uVtp5r95P+6AABxnkd/LqDZEXRPMPi8rs58IOJPvDQSAK9v2e2z7SFLIN4/9dYnay
         tBgFJPP3JQJacNNnO9wSfTZ5SU1Hj+Zg8p4jd1h8tDVoZp9OQDcSEmX5a6y/MZAVR3Y4
         3fHFwzqLiaODwGyWJfUeE91LAPS8GBzTHsNfWheDixbKvVa67YrqbJ7+sA14ibjnaSmX
         mvZQ==
X-Forwarded-Encrypted: i=1; AL+hErHk2UQyx4NQzd05uV+Y26UxnHE/491qy16N6UpPdgfwNg/TlJ8W9HRQ+k8Yg2dXzoPl7xPgM5w/oA==@kvack.org
X-Gm-Message-State: APuU4Z+vs1ANkjBFkCSFYVyGjU3dWt4J9b/IgW9XkxogPvddQWkxnG7X
	G5gluCNa2FUY67KKeej/wUAdGATeM1RN55zo59Hol44RXzIoiMwtQyl9YR29fliabECC7kxPBH4
	2gAPVKXD9Q+0kh/99HL+16sRGfm685qnZru3n9kTG
X-Gm-Gg: AYBFou19M67knXvCclXfioNiGOISCnIHGoecf25TzkwDA363NkVIM41mZZJKrdXNY6C
	YdbiVZzl1TrRthxsooAclJu97YKmxOAwFnBGd20cMtd6knzsIxeAFoLA3NS9bX+f9JJjKsBapn3
	eczzwI4dNR4no8yXG9OtsPd//zpwbFkb+xb5tMxCf/RsVnQ1zPg4Q7avpO0F3Rt+LWRk/Dktj8y
	OJ+6+zzuE0LLdT16oruHl/HzorCfo4czCrkB7+XZXYR6y1N12a1Wd5FtnW4RKhgdlsvbrOxH5jc
	l223aoVM2FhdZ52Xd0FBRgXoxOcSffpPZzILI29qxe+HP8n+kBhNhdWBgONIKVv3p7PUOaLWnvd
	efRfnVkANmSN1toPs5xzTy010n7ND5y8iGg==
X-Received: by 2002:a05:6512:318a:b0:5c1:4e41:3cdf with SMTP id
 2adb3069b0e04-5c1a9c09ccemr1012943e87.12.1795021192313; Wed, 18 Nov 2026
 08:59:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117231352.3816603-1-jarkko@kernel.org>
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 18 Nov 2026 08:59:39 -0800
X-Gm-Features: Aa3M54p70wvOKpegO09-C-J-9l2I7cJO4B_J5hynU_tjApdK664yCTjVeFp42MQ
Message-ID: <CALCETrVUkbpoFjwSAejyA4b_9qEauAP_36i=O8Op1ifp8aUkqA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] Namespace for namespace roots
To: Jarkko Sakkinen <jarkko@kernel.org>, josef@toxicpanda.com
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, 
	Ben Segall <bsegall@google.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, David Howells <dhowells@redhat.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
	John Johansen <john.johansen@canonical.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Kees Cook <kees@kernel.org>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Manfred Spraul <manfred@colorfullife.com>, Mel Gorman <mgorman@suse.de>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>, 
	Paul Moore <paul@paul-moore.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
	Peter Zijlstra <peterz@infradead.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Serge Hallyn <sergeh@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, 
	Valentin Schneider <vschneid@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B91351C000A
X-Stat-Signature: 75a6ijqz636j4nb747cmy5awack697k5
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795021194-408145
X-HE-Meta: U2FsdGVkX1+ao0kj65UD6hE39hfibwHTyHeQw+ppBZMtgvIHrBCY6Ks9rObSZHCPpMJLfQgzBY9QQOgVO1rlwwTApCi8bDUGu67WAO7amXlJxHPMB6UcNmQR3M05JorNPEDffMjSxdEPbw1EGDnYYcUeec4Trioy/wV10MqN2DBRMDjJX/JzV2eSWrdlQr+URoJFi93C4RuOM/dE5xEGPYASwSPLoFEKR7sjTFjp6mmVM4X7R+7oF9tg2fB7PYxoE0E655LkvzDDCESgfuVmhR3LzYoEeRxDHSuW6yJWb7nlX5PdNbXk3aiDoVuDZ98tucIBLlfUi9ivrmTnBADPANXfLn8GbtOIlxpxfZZ5gK1iEuBmQlCTGF860k8qIE8l/MDu99CkwCmZRJwy3AyRtg3Rk4yTM74LqBfc+tn8wrroigalG1nFacNb1erFKtD7/1CmQoRBjxWaZSTGTk5RxaaOPd9SB6OOekMVdHHSZU/uPn2oPdQQIff8oU50oY8Ou0ZxjmCKwJLfBvCcTP+Pa4m+4wpDUFQdK2Kjqg5NtClhfLG8vMbouJT0i4Ynga3b0v6MXJZi0S3bjKbVWplFAW8eUykHsDNGMUMviIeEu7UzAO4NmwbqpjDA9zz9E36EmW6mJOse3JCZ02rh46gGMG2elP/PHdUq8kFrZjbQ7Yp1lE0x+duINggW9D03Q1NT6JRVPaiZm2rQIgow50x3acuWk5ijsSjUkXcjPG7aZampiW3Hkpr7JLJQuqdvXCSVKsTFO9EZFW7IrAqCj223SUHCvT0H9aAGTQkNzPJv/tpAIaW1DU9J6fPw7Lxk7GFhG+oqbt3Bf+vNFc+PvBXZeXVTZpc0yZ9mpiCuF12CJ7wYH01FqFQCM5vvtc3xUxtJLD6i3r2eNwWO/yxnPdeHQNoHPEMJnAXrGSCiSNfaXDI8DfNeaLxSd+lWY3RWjZxbQ6wjbVS83ifXLXl047C
 eTxyrcHh
 jwrhOQYOBTdlWH+kvgtPnW/T1h2dWuZ7dnBRaVq7/xX77cQl3I9N2YiD1O47WyB9/6bwwsPPYynvZYQWrPHS9RrfqG5qKHQPzStZiKevdyE+SW2cfb8qY+eNVvqubZ3sfRDbDN3lWByKarRjAiLSlSZWLmurTAlckc9fMKkDkNdG6yuBB/6eQ7kTdJAsEJd/5lV2JG+KadZ2FfcxiaQh6Sgs529BKIqnTVtXkJ/Z3nruAlLILb5BAFmCxYZ2bOKwQtMDSls91hSxVs1dFV/I1O+w1KNjFmjr3Cquv1i4BU2Ei3XhZ4s0n+QDfNFE4Wyf7JsiwWpBgH0OGVmLNVyo+XhlwPJHWEcmFHeye
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 3:14=E2=80=AFPM Jarkko Sakkinen <jarkko@kernel.org>=
 wrote:
>
> OVERVIEW
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> A root namespace (rootns) is a kernel object backed by a file descriptor
> that binds together:
>
> 1. A full or partial set of detached namespaces.
> 2. A dedicated PID namespace for spawning processes into, signaling
>    members, and polling or waiting on PID 1 exit.
> 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
>    populated before going live, without inheriting host mount-tree
>    ancestors.
>
> Work on this feature started in 2025 from David Howells' container object
> patch set [1], which I turned into a namespace for namespace roots and
> rebuilt around that premise.
>
> While the patch set is manually written, the original motivation came
> from isolating LLM agents. Running untrusted agent workloads made it
> clear that OCI runtimes need to minimize their live configuration
> surface.
>
> Assembling mounts, credentials, and namespaces inside helper processes
> with a half-configured container is what I see as the main challenge,
> and the existential debate around namespaces and container objects is an
> unfocused discussion topic.


I've skimmed some of the series, and I see a bunch of good ideas that
involve using an fd to manage a thing.  But I'm wondering how much of
the value is added by that and how much is added by having a new
*type* of thing: the "rootns".

How much of the value comes from the rootns vs the new APIs to
configure namespaces without entering them first?

For that matter, the cells series also seems to contain a (possibly
very similar) variant of the same thing.

Would it make sense to come up with a patchset that does *just* the
configure-a-namespace-by-fd part?  It seems to me that this should be
an easier thing to agree on, and it's a big part of the complexity of
all of this, and it solves a real problem even without
cells/rootnses/jails/whatever.

--Andy

