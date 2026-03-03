Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7D2AEDA685
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 15:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520D06B00D3; Tue,  3 Mar 2026 10:17:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CEE46B00D4; Tue,  3 Mar 2026 10:17:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35C0B6B00D5; Tue,  3 Mar 2026 10:17:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 21CBC6B00D3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:17:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5FEEC13E3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:17:38 +0000 (UTC)
X-FDA: 84505106196.03.15482F9
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf18.hostedemail.com (Postfix) with ESMTP id DB3B81C0017
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:17:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b="S/7CtiLz";
	spf=pass (imf18.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772551057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6x2klXXgoU+8nt+Cp4vS5BDkY5WkDUr+eoNgGYMPDk=;
	b=3YhhYRLMO1nLOCJq8Llgg09Bi1/NQynu6odaL6legKVkm+2WqM6CBmFrMec7SDlm7/B6Ao
	rqQaOPRnQMETTGDuq21zaGkmZxKCN9d5oF6fo78vDh1/D7dxpwiFsdx7A0aFewWBZu16dS
	ovCZSGUCXfq0Gbj5rfDw+WsmJ+/h63c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772551057; a=rsa-sha256;
	cv=none;
	b=1fXpfyJvWeoAVGEEBTwK0h5OXq3Lz4dCGM66r/PB0LI831AU37K09djDB8+jfX+uaCqp/o
	PLA/bx4HgRTqmIs+afIALIOqv2MooQzBIDlN+TuMtfwS68nTpvTK1JClrkfmUjt29rIWPD
	zKluALpjxsursdMhAaN4L/2GkQMVaVA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b="S/7CtiLz";
	spf=pass (imf18.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
Received: from macsyma.thunk.org (pool-173-48-119-12.bstnma.fios.verizon.net [173.48.119.12])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 623FGHYW030955
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 3 Mar 2026 10:16:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1772550986; bh=r6x2klXXgoU+8nt+Cp4vS5BDkY5WkDUr+eoNgGYMPDk=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=S/7CtiLzhplcy4YOyZ9cm0ma0ZH/o6Y9hiFuKrnoCmMQnSwKFpI2j7LQaOXZe2GiZ
	 2Ss8k+ck21qjKsXwfxyofLsnU1vKDUPLz1O336hG/CLDfBnO8w/GMaycGj+MrF0rhL
	 IxWPnQ1BTNeKGsXhiPUJcoZDPo8n8Be24lA5RsceifbUUvcRfwQUSpp2sm/Q+n2zJm
	 mOXcbCWje4Di/fm/IEfP8ehZ/aFWEgVnnaY/DZeZAahpqh/F2St94pF/0HtTu3xSHA
	 5UtRZDd0ISC/6FBqQ86vrgzohmBgSOiyRun8ohjrF8BS/aIFnZa6zlnqcqqDRAEC4T
	 EZuUd9ULlIzJA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 99AD45ADBA78; Tue,  3 Mar 2026 10:16:17 -0500 (EST)
Date: Tue, 3 Mar 2026 10:16:17 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Jeff Layton <jlayton@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Paulo Alcantara <pc@manguebit.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
        Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
        Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Bharath SM <bharathsm@microsoft.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Eric Van Hensbergen <ericvh@kernel.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        David Sterba <dsterba@suse.com>,
        Marc Dionne <marc.dionne@auristor.com>, Ian Kent <raven@themaw.net>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Nicolas Pitre <nico@fluxnic.net>, Tyler Hicks <code@tyhicks.com>,
        Amir Goldstein <amir73il@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Yangtao Li <frank.li@vivo.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        Miklos Szeredi <miklos@szeredi.hu>, Anders Larsen <al@alarsen.net>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        James Clark <james.clark@linaro.org>, Martin Schiller <ms@dev.tdt.de>,
        Eric Paris <eparis@redhat.com>, Joerg Reuter <jreuter@yaina.de>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        David Ahern <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
        fsverity@lists.linux.dev, linux-mm@kvack.org, netfs@lists.linux.dev,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-nilfs@vger.kernel.org,
        v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
        autofs@vger.kernel.org, ceph-devel@vger.kernel.org,
        codalist@telemann.coda.cs.cmu.edu, ecryptfs@vger.kernel.org,
        linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
        ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev,
        devel@lists.orangefs.org, linux-unionfs@vger.kernel.org,
        apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-x25@vger.kernel.org,
        audit@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-can@vger.kernel.org, linux-sctp@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2 001/110] vfs: introduce kino_t typedef and PRIino
 format macro
Message-ID: <20260303151617.GD6520@macsyma-wired.lan>
References: <20260302-iino-u64-v2-0-e5388800dae0@kernel.org>
 <20260302-iino-u64-v2-1-e5388800dae0@kernel.org>
 <20260303012556.GA6520@macsyma-wired.lan>
 <20260303042546.GF13868@frogsfrogsfrogs>
 <33228005140684201de2ca0c157441d3b6a06413.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33228005140684201de2ca0c157441d3b6a06413.camel@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DB3B81C0017
X-Stat-Signature: x58z88i3btm9wohyyuuqcjioxdsjnymz
X-Rspam-User: 
X-HE-Tag: 1772551056-570016
X-HE-Meta: U2FsdGVkX19m65mYOpWAxjZrW7Pu9sHVc7YZTB10wv+ZkjV1MaTxKyQTt+QMsxW31l7dWjZMCnfvxlZYHxG3FGUCK6ue8xD/the+WmtbK0XAafI9wPPf/j8pbKcSGkTIXeCJRm5pH6TTCXEh/nQphGUJzjc8QIN2+CHQfchJbThg6IBAut+Rzfa5h60P8hFMfKjxv+ejNyAvUekH/5F02I0g2Kt/fyCESxK6vfv0iHwNrRuwUuFo7DdPnkWpaO83Qf5XtxI/Hl+BQEFh2Azw2MUdYusaBdl/gSSvA/rJJeXRD0JtAFYfAPwlpbOIAPVEPAzvTuU5qDIdgkngWFDfRnBenCYdwK14ZSs01moMkpDxM5b6kXOSahB3ZcvebEzGbl3hjXaljEiSnaqKdzQyz0WOs7+n8X41vMK99wiEhP2zfDiaDM4Awc7zfUneVcVz9b5+fC631YxxpIO9wKkisx3lA85XzEV8+XueyEzlaNGb1ltE+Ny1OhGD21BCppzkTPXQk5a5PBDtqyZEde+zsnWrOAYdEyCw59eZkAHbAkriY4+F3eOv4qj+RfS37YJNRjElbWlYlAyqtwfQqHG3i8hT9gdB2B5ycfuyeeRImRErFsp6tNPaIFvmwNqK85xzQ3bOWCKrdfiYITe76NgTluHMyqSTD/Tpjy/hfYjmlcMS76ToM8zG1V5FVmdgm7hPWFfM5b0j5yndZPGZjs8krsJukMeJf5c7INm0ANPZF1cxGpB9kVC7i6uLgjMDkiS4DigdlqL8w2NwtqmQ/tA1xq+xO178Dkn0CLgeyua0guFhs4jd+Z4JguQBfXcHqoGdvF4WDyga5EAijpaEWNgVqO8Gb/K8iJMpkl2j/uzgohxkqT8CJzhRG9mCcJbn/6jjGygH0QaQu4BKdJODDDgOODDnl4cNoOhw5KZCWXRekU5U+5P2LQ1wRCuMrNzhyOHxFkwxkF/UZuMJaL42Ctw
 sJjIkbWp
 kz5HDERrK6Q2aQXnLoujD/SE6ERoVpMs/mnQ6qZWAIu7XrYph0f8H7QKcPnHjvD5/OBe9AYgQgRoFXj6E5yk9BiG3x89bJAmjg6/9lNddpfcvko6CBAXADgwbtUiJiVx5yiO21raFnr/+79HjNj+0c7Da4kaYPVH5Z8HCLnYJnvhtrg5ie5NQYnaE9so7zmAZHAiqSAOQsZABvN33tgf6w8tYcF1ILiAIAKf2SstzG7WB5rkRJSyPVvXzA7kHwyIqQpkuu4ZR4TZpLy67akVKzuVLA8uGjokA1xtRc3KVjDS+NX384cjUCt9e55WJlTk1KwTUuXuRcXQVwNCylNMe1OvjudblLrsO/ROELAlOMEeekjgKLnqp6xeIXuMexZjDpL9hNmWuyB7c+WcDmqEkbGtwMlH3lE7wCDz0E/7vEexO29RnT4Wo049bILrB+C2PnJ4cjq7GrItBznFsFSqjiS/OniiAYPQMF6Jdwg2hFKCXgkG2Dk8DdY3hQr37l9lh8NCekYDlWsc5Q+RVlliG2bPrwvqBVaiJc0zbKVjWi/2XKcvG5zs3fxcT3HqSctjEeupf4ObPctLjd23GoGJKfV2iNxkPfRW2hUertziNZJfYTrht0rPZKge48OHXBT+M4Ur8U/fREVDhkB+jiQjHOqZB4Usuma/Ok9H06viVpSAC/YzwlcMVIh5YUln/mTcj35WptZz76DGk864TYxGrx35R8QvIsKnjqGoLXI4wrEuO+GiUpJnQJPepxvMg9ns3LS7EfCAobZcTn8C8c6eLW9DBh2laUZLr23tJSKcY8dW6fGkOkjHqkC7o9KDFGd9ukK16rryVX9w4zQ7kwAlxyI0QKb9Q87LCX575ZWjbiRYzfwuHjkMXlI1Sf/pzrNQdeKZ+ZgNVO9Pv7suAzRzOUhqxshBzEj20PPRT9yL7nThoR257Y9qHINn5ry3KTeLxc+RDBYLEcYKLVoJXbSfX8TJZxX1V
 nxbwAHIf
 MuFkzD8Z50VWOKqyeu9ahGc1XFlWpGHUCLLK7e15rQJ7MjNH/tNJfxakoASsSGtqKt75A7oPdxOHLQav4ktSswhm3Q6sbUXawByQKWJtldCF8dfiKEj9v5IMC8IngKBQRKM19LkhaAlwrZyTG9fPiNArSTl2TF1ikqwL/KSvZ8CeqMJNY31WDB7vqx13R0tcVJnuilrwY7p2GZ9hI2JTE+/LMsuTRk1Fyc1jyHG/51c3XVDsnAYalPYrPI1+iNto4YQlEuPcFpgovIkKy7USdbnrj+d01LYP7HQxYB6smHLJeeToqA7wQAonsvQ0EVx8VP7Ic14jricefSfbH+AZXhT+XejoIyEiFCuab6EPAouHG2wru4sdqMxA0ZMstGg4X9sDmbYn7qtlYYfQj9kRcnCWj29RVR4iplD6Bg6ulreUTtRTP4Nedqd3jtH0Mrp++BQNllkmbthtQ64661SWHX4TZDbQ+8Yhz8XearExN2Urd9/alJ/u7RBVKVyxvUP7alhEZn0OgTUdVYlNG7GW6lOHowxfCpT64fTQQssReFCdaHdyTofhYvHAkH4p/7q/YsihBPSLpE3LewxN4wezLUqDpBlbIGQsU6mHR2qboYVly0ZHs0BFw65L+BraNnsLZMFd1Y1HucsfzahhczzG6qhBURKWx2GLjq92hWdaesPFLOy614VgmbJEYPq2RRLCkFs+2+gq2yDJyHNLgYC7Vj4wTvTJqYb6nXhOhDLIHdf15ColK5GOjfiZMcNiuai2M5o4HQWgP7nzRdJXhdl4Vrkl+1lBPOCE6U3BxVejRijCJXTZNDDVDtf4TAdYjBDfZ5jQDXruOUUSmIzr2Bqecm8Tl3/kbU255s+mCyelCEWaG36vb2Pa7Tnm3aWuMic/lASq9o+kmNd3k5hncoqljUUazEZ3VkWVKMQaSLbq9hJDO5jJ6Bb5Rnd0BBwHxiHqN37amAGWa885Ra0nJZhl2qkI569qa
 JKNftsZ7
 zGgbl+KvTQ8A1whfABU3IRiPANDn0X5Zzwd5bGkT0wggmbb5eEt/xF/I5VR4XMofZ1zXK1wrG0Mee/VCLMbaqvnAZxx30klrlQDuNgKnac04PCJ6C3cRJsd8Oe0vtAWKLQZxjyqAtwIOm/SG5pWjasx5e3/idSwDWITq1LVHYUvn+ANBpQovgLEEyavdDfvYg7xoROIqHq/EeiobTQXwvvD2t+r7Z4CPpLAFF0lJK9879fEqLi80CXRjC931hVczjKynACC984IX5dr5JlGU04eiAndQgYtvvXG2ikbkq6z8Jgvdlsm4W7RmYn9dhC6l5j5e2VrQtIfrufhb1T1fgcKs/eOU/xMW/e2cj2Ia1/GSdoZC3HqdtgdvvJaXPWDxOIrd52CKJZZtiZa7bCtp0A+l+Mwq1IzcgK+PpBdT6eUe4LIGJe61KIiWFE+I0WYKhHFmcc7QhxtChufgzBUKZqmJelXeWeSyFdfVO8hWRmbYp1oLvJ6Fl+cZ7/8nWdQ3ZuqUEwCzQ6b1SIJZuGADXXq8+74Er+xX8FAl4i9YkGWUrHmfZLT4Zf+ztzf8CrYGblCsONAiKld8H8Vv3m+Rh8ROVUEj5prpqeLyammYZdA2k7EdmCdGi3O/KjVWOuZCz94x/fW4znh9UwK1GfT/cc25VIXcle2v5YLmf429e6xv+kiEKz6aQFE1PrJtTh4uc60DAPZs0RjckWR5sXp3lTKpX73gGfeZzsxJlqiQii84BdL7KvaMc0QQIVQsfo/iQ36EdvHr3H0FOsq8mVN1pcniH6L/6JfJgb9lhU15OY6Q6boruJ4QNQE7m6OKnOMY6Oq7u5UacJjvfpurHtZFwFHv+vnnjYbKB6VY1zd54bRVeCNrdqgSCFpycUP+1Z7CvugyWLOSmBQNhapJNnIpNAr2P3drN52QQvdNkUBueudsqUKOJ13DVe/qT8FauHbF1iaDRuhFnd0QRmlvjolhq1zNA8D9j
 gkSJa/TW
 xexMfGtBt/eQXA88sNxo8Sqiam5L5Sld8PbmHVa1hgioAJFyzRT5Yd+jbrOZrH6bUQzYTK5cxSyClwU7Qgyw8bOSYtonyxyklnJD3TGgGWjLylsGiOn1gbjxw0d9A9cTJ6lyH7+LCT2RvKe3iWXUu6Eps/jeu2EiLRaFqZmpsv6rHDYOouFRUY8+Sym9GlUGoZbS3Tc0+ZsL6pGxyUsWC66qoH0vejmjnAup3hqdtjLssanPQcz31zo5TW2Klev3W4HQeW5QW3GzGQf9PvMkl26jnJX7uiP2vKMJBCExR7i/vxbB0KXRnEtdBFW7Gabw9p1tuiGmxXnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 05:53:39AM -0500, Jeff Layton wrote:
> 
> Like I said to Ted, this is just temporary scaffolding for the change.
> The PRIino macro is removed in the end. Given that, perhaps you can
> overlook the bikeshed's color in this instance?

I didn't realize that this was going to disappear in the end.  That
makes me feel much better about the change.  I'd suggest changing the
commit description where it claims that we're using something that
follows the inttypes.h convention and making it clear that this is
temporary and only to preserve bisectability.

One question though --- are there *really* places that are using
signed inode numbers and trying to print them?  If people are trying
to use negative inodes to signal an error or some such, the it implies
that at least for some file systems, an inode number larger than 2**63
might be problematic.  If there is core VFS code that uses a negative
inode number then this could be a real potential trap.

So are there really code which is doing a printf of 'PRIino "d"'?  Or
was this to allow the use of of 'PRiino "x"'?

	    	    	      	     	- Ted

