Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F747EB3641
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 22:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35BB6B0122; Mon,  2 Mar 2026 17:58:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E4D16B0124; Mon,  2 Mar 2026 17:58:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863556B0125; Mon,  2 Mar 2026 17:58:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 73F156B0122
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:58:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 541161A0342
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:58:48 +0000 (UTC)
X-FDA: 84502639536.20.597986E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9B7988000D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:58:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=efMzfnop;
	spf=pass (imf02.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772492326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flSjTypklpkRIUGV+2Bt0VSusBh1upu9JcBZQms5sKU=;
	b=6oBRFsgkWmAPGQrPkv8w5VMzJQF+/HjhvQ9NpYCDdrqv1hkmi2PLNtPze+JFDvSnDk+U2+
	mNvATsLOq9o2www8R8fAxKBknJCKYUohFaXpppShVtbRLzlXkB5YIUGqMlEe2lyq/2h9SD
	tc9coynNswj3LgPqLh7ejuND9jy/sC4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772492326; a=rsa-sha256;
	cv=none;
	b=fSA4ffin4uFY6131rBO3eBW7uy+8sWKDR1bx24st+5+2pbPkVYzrkRkPE2mpkxAu5H2kdW
	G7UrOT0npQIK0ti/f12QYyf4bCmw3Rb9zBSj9V9SUJbzsQllM8yfkDFYA729k/aSn1uVjr
	Hh2+kpFvsrfn75xiacxnWhbkHZ9qDRw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=efMzfnop;
	spf=pass (imf02.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D4E2F60123;
	Mon,  2 Mar 2026 22:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998A6C19425;
	Mon,  2 Mar 2026 22:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772492325;
	bh=Aim55mS4QOPHiq3lGIrwAq6clR3sCfuIHZBW63a7sLU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=efMzfnopH2WSmNEYj3Hb820DIXfhzmcNJQ+sj/RP5P5QhetapCfR9yKeXE3Q32qWL
	 YVb9vOAaaOxUE3OlnOU5qf5pp6AHKS/GqlvGT2NTaXOtfg8ico+u9+NLobylZ9jGe5
	 LIRJTz6mbzZrhcM3c/rF6WYhaGgyQIy0R+sbukSxUfdpvrrZqMaAAPwWkFe+MDR+Vo
	 V/3L9nVrysUo3+FPRD9XrnVjqJAs9NpsT26I97mvOAs/um3Zb5oulM1EyoABscyNmC
	 z6PR0/q/hUZXduKPkmtA4rzmBEcDgyq0zy09oPANN6tF4vzCXJvY2VgdQ9jrOAeA8T
	 /AhcQbZn+87sw==
Message-ID: <d13b3907-3bdf-4a13-bebd-dc6081d40600@kernel.org>
Date: Tue, 3 Mar 2026 07:58:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 100/110] zonefs: replace PRIino with %llu/%llx format
 strings
To: Jeff Layton <jlayton@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox
 <willy@infradead.org>, Eric Biggers <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>,
 Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
 Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
 Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Bharath SM
 <bharathsm@microsoft.com>, Alexander Aring <alex.aring@gmail.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>,
 David Sterba <dsterba@suse.com>, Marc Dionne <marc.dionne@auristor.com>,
 Ian Kent <raven@themaw.net>, Luis de Bethencourt <luisbg@kernel.org>,
 Salah Triki <salah.triki@gmail.com>,
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
 Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
 Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@infradead.org>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Yangtao Li <frank.li@vivo.com>,
 Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
 David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>,
 Dave Kleikamp <shaggy@kernel.org>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, Mike Marshall
 <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
 Zhihao Cheng <chengzhihao1@huawei.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <jth@kernel.org>,
 John Johansen <john.johansen@canonical.com>, Paul Moore
 <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Roberto Sassu <roberto.sassu@huawei.com>,
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Alex Deucher <alexander.deucher@amd.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Sumit Semwal <sumit.semwal@linaro.org>, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, "Darrick J. Wong" <djwong@kernel.org>,
 Martin Schiller <ms@dev.tdt.de>, Eric Paris <eparis@redhat.com>,
 Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>,
 Johan Hedberg <johan.hedberg@gmail.com>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Oliver Hartkopp <socketcan@hartkopp.net>,
 Marc Kleine-Budde <mkl@pengutronix.de>, David Ahern <dsahern@kernel.org>,
 Neal Cardwell <ncardwell@google.com>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Remi Denis-Courmont <courmisch@gmail.com>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, Magnus Karlsson
 <magnus.karlsson@intel.com>,
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
 v9fs@lists.linux.dev, linux-afs@lists.infradead.org, autofs@vger.kernel.org,
 ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu,
 ecryptfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 jfs-discussion@lists.sourceforge.net, ntfs3@lists.linux.dev,
 ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, apparmor@lists.ubuntu.com,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 selinux@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, netdev@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-hams@vger.kernel.org,
 linux-x25@vger.kernel.org, audit@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org,
 linux-sctp@vger.kernel.org, bpf@vger.kernel.org
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-100-e5388800dae0@kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260302-iino-u64-v2-100-e5388800dae0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B7988000D
X-Stat-Signature: scqntcc91ap35xaqztawfywbzpkjnwaq
X-HE-Tag: 1772492326-812370
X-HE-Meta: U2FsdGVkX1/Aif9yOazQMidU7UNftQMbP4zKBwT+C3oIROoS2mOqyF4q3J3Telc6Wdz7k0yfDK+FtMmO98w6S1FLTY6oYPifC0HKBEnrIPu7i+ycpHMVJH78JSjjN8HZAq+wIHknMVYxq1MHDtfqxYyxu7Dapq6m7BxjuC4U3gGpANpCbNcUI/8DkwIxum0f7XYmRsPPNOgSK5g6OeXBTRBe8vgbkuh3B2jHpK3QLW3ykNoI6c3F9/+/70Insz6uY77bT5c5TpjwIh7DGOc95bj4iwqe8DS0wl6ekMwMHVzRAlMqEpzGWQj/VJYq4CiOtksEVT91tDonyTMBC5xzrH8WoxDcWgQmLEHrw1T/aNqCCbDHJBU46GMtcad71IVA5TxftR6T1uLCvDIFIMDGjTb3E+mMF/eyutLh7++m52g7wmVWm2sXLQjx1Tc2t+z6lwozvJcBDu+3M6fqMf1ZIbPoSbYYHeH94EEQ73Jp/ehYjLj1CmZDBndByt1U2hBJrdQg3VicGRkWkc2U0d3IvcFx4V8RqkRDcjjyvfQYP6YKWl7/4CU44v15wSvxCDLKwjpoKLxyHTCM1ibhXndVvroSJ886B+yTfSAGPRCfQE0WXSs7QcK5K3v9qt9v2DqVF+B4t00l1TBUFNV4gkhbfIWhUEHOCen5My+XL2b0sd92QsFZgWJ2bz8RpC+oG7J+LwuclfYPCdlLiBv4rG5XUCGjMsoBbL59Lp7CESK7RUjK9hNe3TJTEO2aFvmq7YmB68030OIhzhi43h0ipmUlUdaPdBjTQw/xvWAcu0y1HHYWest/wNxO4aHDyx/pr/hOQc+B0WYeVFlE59crc6bx0dxWg1Q0eulkh/yV3nAntDUoDpRMhuMG8jh6chVYPD1AHPCwcWCsQ0sLGAREZBRr7LoOxU4NUXOSvtpgk1QdSJjx9jsqqcLI8VGbr9iBiEYyiL+dU+ViSReg7iGZnxA
 o1VtMxb0
 FfBvR/1j5SEhyZg7iWlIvM6i33XeilzojAxvbo2fbx//pfQmD9tF07QTvoN/M6f+E0HWVAlvNCC+we0zwtbq8awVciojYGLjTT3Xtc7CC3MLRsuoqXLsCTOCF4n1Xm7bIjv356hRDM4z1YyduKBJdpouNcczqoT6AS+5t6yrOW+AxlzdY9om1nYexOILUID0DSF93pg7wVcnxC0gfo+gnsFKY7jz6MwR2leocYGBkivwry0aAy6nDcsZKjSXboxxkyLraGdCmeGefuLlmUYAUTaumjIYsj0TNK6xH3W5aZiRyCayiAMrK0bz3OQgRFfTH+ELt3qTUF0fxq+l5ddTNM1+FDxInYJWuah/EHUCyJyXB4+GZQ//UIORqo1lpzlkDRlUnHYULa1I3kIUxGPGuAZ8b+swMJBopxSWkDKAxXL5KcvW1DAwHObEtEtj1sB5+Tz132TPRsvEuxAw5YblrWmE0xuKDwFA8wjXidXvvGbdps3CBHHiqRLQwIZ2DROHl5m+xm3YhY0qQ91QxMFzYBNRaG7n6hCTtZizBm2rQYQ7xCemcM8rygVNJlDwihLezz3w1xfo/8d66VwkPOPkPXA7Ff6fNvkqv+KH6o+s+aEd2FP64lH9P5Cosc++fwvPqONFD6tMOSsX/7LvZhmuBKzMWPBzPs6hfLEEoXmJkfBXPpSBwYp5XVHB1EAHNTIThRou+Q6QQ/jqUJdrUibxdDJKezWK4nOYaPNAKgLDFXI6N7ev3/L5NujqBnFKJLNre7Cb1DxdpZEKUF8BTln3PaXFQZ2+Eejpa9erXaFl9SfIgS39pG5fv/wvMKJiyC8TS05HYVGo1bSPJOkV0U+T6wY9fYVHlLnPkx1sXcM822YAENg0bxQm/Tw8jAVS7qCObIbyz5y/w9VtYXH7dWEiiM39kTvED2r0ksTcMJRFrkEHa1KeITKQvqRky30a/I5H3DivThOU1M4/8iSiCmM+Zk7OQJ7Di
 GwJCS5le
 3DyJK0oo93onWMeR7hKLXlNnMecaOzLmL7OO4hRtVPPChLgUPl/a2snZfKpN+Kd4BOhWJWK3fY+0ldDPPzu8IRl2rf6Xds55g5VzqqEK2H75o2Aq7IuTg2j3IiToMdImT9jyHHseDDc/xfl2vbnzO0llEh4SqlDGLU9+7OUwWtQb98G0HKM8gEBWgZrIX3R2wOxDSYxgHQWy+cusMOxU8/jYeFSrdWmr/nGdVd0uI0/e2bjIEJJoMJdcEvHS7bv3JY8QnAvxZhLLCf60HS5ZGwYcVJCIMpLaxgEv1GNIIh691xT0BoPNtLrFUswTI44r2OM/ugMFwtrxZZ8QeqcOdP51tTEwvTFMoykUMhb3j2H8IX90jicBx2Rc68jJI8Y9FqbwEaF6PYgkqnaqy5PSWdN1cdL68nk4UmXZPSaTnvtLfTqbEb8yGW+PT+yRD7idNgiNinOqNqnV/AOnEqLTVm0/iWF7UGY8q/PGFWh+8TaoIjc/izqKC2B/yUerR4yErEcVCPyYoH/7bEFINWHjLHggyZAGA02cofgXM90UPUUxZW10FVQBQKDdyJCmtMB5ajpcUZyxfmfrpscMYURYJQXJ6RRMxgMQPOHU+WFS6k+6jSom9AeKI9EamlXr0IcoLC0vEhtKKQiMmQbKC4cVotd0JZ0i5VDNMt0A3ujF/1L8oF6LPeMlA82LpfBrVUB6JcFfF14LMVwJC5sAIWx4HyWLF+fZOAsiTSHwMyo3y2P1J+yZfyY7pog3ern/bZVFOBt+iNIxOh5DRKILMpTc0PBQdtbfH8tPU+Fn7W15AO+m4Sl+Y9B6JEhlwE9PRz5dTz8YqOI6fEXOuCsrj3STfP9QVxfbpF6oTNASL7gezRqiss4jBHhl3nPTyKLb8A9u8dXh7XkWQylK/8N729UJPpKP5Y89pT0Sp22RsZKU0tVhmjRKcOAlwAUaY6PPIJFyiZXk8fR3KUCiD2OmVS+hEO1AeKmHl
 apw2COP3
 cl7+GEL0Y9vFquTCw8AnS1RoxI97ecPqBCWQGuksQoY2EpxgZKQqWJWwI66SSU0w97M+h3NfwOSUVA9Wtdi7PeK92+bxy9fYTZLNBV9ELvqtcgy3n4bd3RVLwvvBvIxgx+LP41JhDamXDGHcFDK5pI2x/Dkx2w+0XkfEDBOEOdy0rjQw7RiIlQs5CFshsBaGS0b4zFxcxk/A80DHAIY9Ue3ME5B9onNiPk/GbA3DQx2sqJcX+Kc9M0AP2t+ud2EC5Rx0EUvKLZCWtngx0oZ6DCYo/9vw660dzh97XwJ40xbahrB8dnREM+46c7CHWY2hJ+cTlQa+JQ28ddXQRAIl+A6246KBZXZE5PLlbkbgqPTzUl9da6gGHvJELGbpRf3yQubsdZatv9PTdacS0Ka3uSfqhpFaWNYLa7m1P8GA0JMBm++dbrYm8IwrBF2gUXSiYG5KAOKBcmFT3wJB+fGkuVNqMAf/ZJX68W+XizjCKLmwoGoLJNpcPaNOQjyJuLoOQsQELK2iJ78mucBs79ZkputkjaCG75FAAVrtFmFZImdcfe0L9vrXTz8EkMKfxE0CvP5kV5sUvmWextt5DnfOuY2pqyGn/dLsKYYSWps9sli2Pmi2A18kOuQL8mxPP6thcE3zDXKrOCPexezR3eGXeIvpjD9sxVYSgHlcZWwYkp+/0HjbhzqleZoUP3e0wIlN/1hNFT9+5rgeTTIYnfpjeAgjHWM0f3JvZKtwNBNq8nm9ztYmdoYCAI4SfQyYk0f9yudMN1SrnhnWvVsdOTZWluB8/VeqrkyzWzKBEfXFEPyjbM5ZqhHpox6BnGJIp1g5n2HOpSKp+UcCDjvWOl7GSMgogV94OHJxzbqat7SIoEGeB+K0FhzvjXcI813k7K8vYjy7ZSN4E5hE+giX6g2mDpEYqL2flPbmrftjVfOI9EhWYNYQ8zH9MiyaNu3XAQIfV1oB58xwpUl8xNHStkuR531Qw3hJy
 1mpnYu2y
 h/Gbe2EB5pIfNjxfEGQaUxGb+J+whx2dsIvw3DJtUY36YvKO7dJR7GzvGcO/HqIByxFJplW/Z/8tV4masaBScORIIk1z1/bbVJ+xQYcLEVjzXLwyYhIvaTZK5BxjcVW2lgXmQrLfbEnQpcGNcWRbPJaEuFw00yA2oh3Qd1PAJiwl3P0VgLHXbEhfcVQG0B7d/V8fImAH8seTYtwdxi6q77k1ZMXB3RCd38UicvEswx2bAEJ7JKfLU73RsKeCctqJi2nQctFZ6LFcTELsM29ncdGZycAjjL40blTfkfOFSBIUt3LiXFpLj1wN35OwE0ebfAg/iQ1pVojvz5NCSgrAVJk5L76IHW991Zd9LIlXvAaGlWWiQauLK0Csef+EYl4NpXIahWVeDHX/4HKTj93yMO2fVjyAuVenBtMKavcNxVCBtsa9p4JtBfyzG4Maq7QlavRe30VDbZ0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 05:25, Jeff Layton wrote:
> Now that i_ino is u64 and the PRIino format macro has been removed,
> replace all uses in zonefs with the concrete format strings.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Acked-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

