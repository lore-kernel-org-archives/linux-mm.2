Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2EDF606A330
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 20:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=awKUlLbv
Received: by kanga.kvack.org (Postfix)
	id EC9BB6B05B1; Sat, 21 Nov 2026 15:17:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7B506B05B2; Sat, 21 Nov 2026 15:17:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90C26B05B3; Sat, 21 Nov 2026 15:17:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADB616B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 15:17:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2AA10805AE
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:17:01 +0000 (UTC)
X-FDA: 85460235042.23.FD74E95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9189A1C0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:16:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=awKUlLbv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795292219;
	b=GgXNyaQr/izO0D98QPndk81StYDzubLeQ4gTmYFwqPoUF2GjKK/Whx1xNpR98c3f0jnfON
	8tsqqcIxBTiIfHxzOXEBFSQC6WVvZS38jYPvt7rEhC3T50vTEwuvCZjss7suckcnApHLVV
	7h0LcsNRM4K/Oh3asTK9F02UakAI5pc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795292219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCBP8JNN9LhYmA42mMEQijOkZabItzYoL6U32M5rD5U=;
	b=4v9Y6zijJWUT9QVvLg/UIP3sXaiRe7XErvbzIBNm1EHIpMMz5KWXVxs1FHw1FwcXHG9tOV
	VNEF5QUT7h+K56pBM188UX/rnB3sTWfHDCYyeg7dx9Z4qLPiZlAQxQdWPn+3HlIHK+zJDT
	U9WsM15M+02mSFiyVFTZNVoWXR9SjUk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=awKUlLbv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id EE3246110E;
	Sat, 21 Nov 2026 20:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 24FC01F000C0;
	Sat, 21 Nov 2026 20:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795292218;
	bh=WCBP8JNN9LhYmA42mMEQijOkZabItzYoL6U32M5rD5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=awKUlLbvP1S0RSzq6or2hZk+BFppVeROah3E6sRNOD8PhwN/YJIWZpiBtcRyolg/T
	 OAor4bxjQjxffQ2cWBYSzf+63SP3VWuAFwgbj5r1R8nWBvFl0qsUuXzRDQrkVAzDwV
	 4dtkFBBRR2QZ+lmw2F8tH4liqDs/uESzlGjQXBgpRCOVdHoZucHE/KRjglh51qB0Ro
	 /HfEC2+MWTkQpXSu7fSpGg2hbdcqX6hRvudPt9RKoDxJ/ULfNU+vmQPE2IQU4gW6nG
	 HWsg1YjK73T7okHlUCt6GK0kxjkG2SsceSqSICwvFSPIs/1O8o0LWRsbEmSw8S5gyc
	 Kh+ZH6SteCe3w==
Date: Sat, 21 Nov 2026 22:16:54 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 13/25] rootns: Add rootns() system call
Message-ID: <awH8NsS5dH7FTDPv@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-14-jarkko@kernel.org>
 <awHsvz1vdlwsink0@kernel.org>
 <awHtKMkyGEPTB17G@kernel.org>
 <awH3BUHarwfCPJwi@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awH3BUHarwfCPJwi@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9189A1C0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: kkntxsz4pf671jh7m59duuk8mju4pqkq
X-HE-Tag: 1795292219-344018
X-HE-Meta: U2FsdGVkX1/O2rCa4niD+8GrGZB9sTaDUke9/VkivXAu73HlMNjxfTcZo6ppn5svO5fEHX0SybvZe9VyfofCx7amgtwJIIM/gCjT8T+kIBykPF7UipO14Z53DLnvcgsWL/TuNQ9Yt8Z/F6e9dcNG+/0JRj5izWn5LU8XqJSdGwZ3+eEuPnZ4I8bNhSRy19iDcGapPGHLalElW5zTFLFjSnO0WhkBTCVpXFxSwjV7+3K/j4pnU8mLD5gJXI9+x20LS8YYSXUdhGPRKFMre9099ID/BAoTqNEstQ2cwd08Iff+6aFzfbiRwg6su92RayedH2vQw2W8rgPVgJjluRHfG7AgWovZFbvXm9rqtnkMvvIKX2Va6CR3PPnYdqofo7ydeq4BCLxssdyKW3xlSpMrYpCsJsyYV0mZf2kiQ5nAMjM3nQC2WkX2j08NIcbG/NGmLDL7Vpx/dzoGHC1Lal0ZQ2VwcfMPq/SBs+8xzMU24a0J9LdjT4ANM/dVr4n8sFUB0JijatSGImobEBtBUpxr82t8eSlUGieakhWLTHuSC/WwFnpgMMEYG3zY3WvEii3bEqv/7tKX3Mb73l3Jb0TFl4+gJGTNw1VsSZ5KT+xqULwYNNdUG+CLlWAFj+sla+n1zkBZ+Kw3M5KHF+P/9XCRZra2IlbuZ5RG/J98efynywE0+pCMaHJqIjpb2NClrIiKwUMzJ3mF5SnIeS5y/7w3z7y4n+eQ6SytnqCkgufDgZ7hWmU8sXpbhr6rY59+gjPbhomVamJTJRjyCaBaeihsMt5Bj7OyDfazlyxKraZND5mukKHVW/ja/LGJG/O3It4pV7QuI8M0tmikghZantmD/MQ1U/unywFEbegmDFyRc8sxp10ttyfM/+I84zrlGbkzeXwti07En8bMdzq6m5ixmxuoWeDN007HQQGqIDCNWSGmctpibhd8QbEHaZ5iNQUUE4ZEmPW8wU37SODmSQ2
 s8QvcbTy
 aT2k7nrrDcaUOpbgCZ5t826O6xB0Kvd+Xecvceb/DdwSrMreDQ7uvRi5DL14kqiCXbAnP81aBp1S1X6uSMG+HgHFL3p+I3yrg8Nyx8PQTT5rIkJLa1hbaxOJiByRtcFAeGCpM4KDzChDJqomh7MKD5pQxp//vTuatnYpez1UEYr2gwtXTUhYwMLKQyoCSV+53fzb+cTvG9Qh9KZVC59AoZcBscLQfrVoguPfZ9io2D+CQMo40ufn8jYaELWouRZhEEvrAzLCUQ/aqZkBMlLm1tjwfFHgT469UyxHUBcGBg20KL9KZcELZU/TTDnRPfeXAukrZt7AdD+C2496Zp9Dkdjo15TFWF/9uwdqaR3a4l9L24he0rbC+g0qsC+XOLgUEHnAEWgu9yWZGoTdmGU5s4cr+/BS5tMe2OSg7EcAXOH9BEH1KslcmmDhQ23x+CaqSobdAbzSgxNgYpoNeyPUqxBQ6EVKquQxDMTEXkqacuBYHx5Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 09:54:50PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 09:12:44PM +0200, Jarkko Sakkinen wrote:
> > On Sat, Nov 21, 2026 at 09:10:59PM +0200, Jarkko Sakkinen wrote:
> > > On Sat, Nov 21, 2026 at 02:08:32AM +0200, Jarkko Sakkinen wrote:
> > > > Setting up an isolated namespace environment from a multithreaded
> > > > manager process currently requires helper processes to call unshare()
> > > > and pass file descriptors back over sockets.
> > > > 
> > > > Add the rootns() system call to allocate a detached rootns instance
> > > > owning a fresh user namespace alongside dedicated empty mount
> > > > (CLONE_EMPTY_MNTNS), PID, UTS, IPC, network, cgroup, and time
> > > > namespaces, and return its control file descriptor. Finalize the nsproxy
> > > > time namespace and pin active references for the lifetime of the rootns.
> > > > 
> > > > Co-developed-by: David Howells <dhowells@redhat.com>
> > > > Signed-off-by: David Howells <dhowells@redhat.com>
> > > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > > 
> > > Syscall name is outdated. I'll rename it as container_create(). Does
> > > not have to be final name, but is a better wip name.
> > 
> > Something more non-generic as it inevitably would collide to something
> > (did not check). I'll figure something out.
> 
> At least for the next iteration I call the object as "vault" and rename the
> syscall as vault_open(), and that is based on:
> 
> 	$ cat /proc/kallsyms | sed -n '/call_meta__/p' | sed 's/.*call_meta__\(.*\)/\1/g; s/\(.*\)/SYS_\1 \1/; 1i #include <sys/syscall.h>' | gcc -E -P - | grep -v 'SYS_' | sort -n | uniq | grep _open
> 	240 mq_open
> 	298 perf_event_open
> 	434 pidfd_open

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=vault

Br, Jarkko

