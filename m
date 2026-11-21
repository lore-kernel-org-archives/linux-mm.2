Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8B27606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 19:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d7Ozz2wb
Received: by kanga.kvack.org (Postfix)
	id E06386B05B5; Sat, 21 Nov 2026 14:54:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6396B05B6; Sat, 21 Nov 2026 14:54:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA73D6B05B7; Sat, 21 Nov 2026 14:54:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7C26B05B5
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:54:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2854240586
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:54:52 +0000 (UTC)
X-FDA: 85460179224.16.BA79A7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 96AE7180002
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:54:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d7Ozz2wb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795290890;
	b=FK5DNB3WJl8rpqhzTEn/fI2cKzDVQlPvynH2vvRDLy5VVUAvvClNXtqo7K23Jr+WYWwB8d
	xC9+9mB3xEUfiL3SOla02XgnGF/k7/b9bOPed4/FLlquw226a8ESE2ixbWonY2ryqxsP/6
	ZwObOQfiIDJirgah1c3vIGAcqqm2e5I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795290890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3pGh/Nf6VGkSVannc1t1HSa1H+w+EAysJ0+xryVXV8=;
	b=LHWFLYQOZniieS67RRWvw7BauiC9SnghXXwlAq1iZp95wa8Ws5V5WsfJLmcktj/MgrtRkv
	8RXaHU4eeFmCZwb5mRqLjYzjpYdMAhWpDdtZI6GrOOGmNGNIA3dY2BucgEk8NMtdjHCjW2
	naXStP5hC2kAiHmV3ROpnJK9OglaTjY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d7Ozz2wb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 0C80060D14;
	Sat, 21 Nov 2026 19:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 39FA31F000C4;
	Sat, 21 Nov 2026 19:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795290889;
	bh=k3pGh/Nf6VGkSVannc1t1HSa1H+w+EAysJ0+xryVXV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d7Ozz2wbWDdWuTNONSLPuo43rI9mXsAtcpQviZ2TpeM6KVoRdztLFFZihLhC9YOo4
	 d3eKmkFXEetcuCZ9G4+sdWZl8ixRE02VNs2YBIZFvvc1sUUs84h1hu1NPNQyBSmI6g
	 Fb2SGh3KWHgnt/RWcd4GdMO6CEBCKUpRNfWJhey/ix8VC2+L2LTKCxGIZeGI8nNi4h
	 6HjCcVHNq35yMBZwBS3A4nM0Ubvt1DztlVj/Wr9djhOADA2T+ACJmy2JezPrKfzp7B
	 jXHaF8iQZkKNh+gpgb8nmCc6QFo/ofQ79XDWm6nmUbUZH82+u97zhW34GWT5nxZJHm
	 93jBTnsZk9nZw==
Date: Sat, 21 Nov 2026 21:54:45 +0200
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
Message-ID: <awH3BUHarwfCPJwi@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-14-jarkko@kernel.org>
 <awHsvz1vdlwsink0@kernel.org>
 <awHtKMkyGEPTB17G@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awHtKMkyGEPTB17G@kernel.org>
X-Stat-Signature: 7q6911mgcjdfd1o5oew41kbkq1t1sntb
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 96AE7180002
X-HE-Tag: 1795290890-91134
X-HE-Meta: U2FsdGVkX1/PzZUVhhzxnULRb0YcXX6uc0hcPGOY1Eom7MvhQwMJiX16zqI8SSrXnvHuQBkURewhedqjXO38l+VUI6CSb0Ur4v3iMudo8kziTpx8HrTjSg4twpPWsZ0tjFuv7eynU/c8NZE0iF/8Wix5PCwjC5HLHHnDwv91bhi4QHje/StfFv4KOiRdTodhZ5rTF8pn3Ck41Ld6ncO4WOGLHGHU6I2l4A/F1cN1LCXYwQKzgFKkvaAH88aMAz46qydgBZeEFKLj3rAUBN/HaIcmXHyNm7IRi+g58oX7fcA+92U1VZv+6/iZ2ACMwxlK34/Jf1K8VtrYcVjJ4eo95PMbKnPBjAV3ONnqdT9nSAzf55NHuRrYXY1tY6JExjKVQKF/eS+pbibpKavukeDbp9oMWZr1YEKu0h1qte85Cl2R79KXOS9VZzqczET985cJ8rkTSOXoZOe/Ifx5etd+4FyugDTduV+gcVKnYw0gWEDKL718CNlRAatJckcVHIQjHUn73+C/ONf1XqNeIaw80nPTdNdKX/QF/JbKj/zw8lZrOR6fy1OskMxEs+zZbqgbVNlzE9gjGs1YEzhOx5Gpx0S8kd9i17ogkFR+fod0878PykwTt5/rHGMRwm1vNqcR0PZw9tMEs/ALLdbvTaUY0NMD5DGo7SLX7nm+5rzhTowQsJTYuQyCRNk9ACyie2rdNOhWo8FvcHr5JJUkK5GUZImy0ww0i4VdRMQXzmO2kHC1V4JeT/wuvjuV78hk+diS/vGFrgPXVOTIo5G5yVeFeLeFso4qOS01ONYrMGo+R0TvsJlshGDvfZO/npmqUi9waaCr8zAcR962M0Om3HNIxehnkD5kvkGrdrXbpZPAJDxDggOqA5kVW8iGdGvGgOJMner+cGRDheiuFpx8/7hGCizwLpuIMOtByxUpSHzLRA1w6Q75l/jrl2zGH8KzhPmPsOf44y8BFb1WrpwJLJZ
 FL/UIIdF
 Y9cjAZBaZtroT1C3OPaWnapFr7HoBEAzhYApLrlWOGzZpHhS4WRSmpLtbtZq6l6rX7q5NX8b4IlTvUwwnz0nuEadFs8T4gbA+pDq5mIKB4cXD6vf6O3EMbp10PpJ6+P+nIK4WawvsYydz/QCeMdOtJHAhC4HOICQkF9Q5+1cBhBEVJUM6K45tJqzXJmayy+zS68qpntDZx0vfEsS6qo000RFcm9wftUZfIo29DpHMpMI6K4+SQTZi0hBHDkK07anjHP2WpdTT54NK5463+duOsw0Ddc2Yk1XlpbwPqHihL9Y0/FjVIj7ZU2r6N+yesFB77GuGqwLavcNf80x6z+46pUMXa1KyqDnz1XQ70e5nvj+EZ7v84lC3wXRTxrXmtToCQbBJo0+iJLFAs7LSj1oC38wwyh/OZn0ZUNuWzGURuMj+EMhhOA3AeXl7Of4qThhDgYMMAsSj/LM0mEOosY5N+l0JM3+IfZkq8TRbaqfHnHtQUBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 09:12:44PM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 21, 2026 at 09:10:59PM +0200, Jarkko Sakkinen wrote:
> > On Sat, Nov 21, 2026 at 02:08:32AM +0200, Jarkko Sakkinen wrote:
> > > Setting up an isolated namespace environment from a multithreaded
> > > manager process currently requires helper processes to call unshare()
> > > and pass file descriptors back over sockets.
> > > 
> > > Add the rootns() system call to allocate a detached rootns instance
> > > owning a fresh user namespace alongside dedicated empty mount
> > > (CLONE_EMPTY_MNTNS), PID, UTS, IPC, network, cgroup, and time
> > > namespaces, and return its control file descriptor. Finalize the nsproxy
> > > time namespace and pin active references for the lifetime of the rootns.
> > > 
> > > Co-developed-by: David Howells <dhowells@redhat.com>
> > > Signed-off-by: David Howells <dhowells@redhat.com>
> > > Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > Syscall name is outdated. I'll rename it as container_create(). Does
> > not have to be final name, but is a better wip name.
> 
> Something more non-generic as it inevitably would collide to something
> (did not check). I'll figure something out.

At least for the next iteration I call the object as "vault" and rename the
syscall as vault_open(), and that is based on:

	$ cat /proc/kallsyms | sed -n '/call_meta__/p' | sed 's/.*call_meta__\(.*\)/\1/g; s/\(.*\)/SYS_\1 \1/; 1i #include <sys/syscall.h>' | gcc -E -P - | grep -v 'SYS_' | sort -n | uniq | grep _open
	240 mq_open
	298 perf_event_open
	434 pidfd_open

Br, Jarkko

