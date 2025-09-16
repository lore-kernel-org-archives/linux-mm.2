Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACBF9CAC59B
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 19:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137F58E0005; Tue, 16 Sep 2025 15:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9138E0001; Tue, 16 Sep 2025 15:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40578E0005; Tue, 16 Sep 2025 15:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF4C48E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:52:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A3BB570A7
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:52:26 +0000 (UTC)
X-FDA: 83896160292.14.AB2343F
Received: from smtp69.iad3a.emailsrvr.com (smtp69.iad3a.emailsrvr.com [173.203.187.69])
	by imf22.hostedemail.com (Postfix) with ESMTP id D7745C0008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:52:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=deepplum.com;
	spf=pass (imf22.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.69 as permitted sender) smtp.mailfrom=dpreed@deepplum.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758052344; a=rsa-sha256;
	cv=none;
	b=IpXTpJUisMAZNAGxUtjF/LpJs6c8Iwm6v10OOORunBDe/17hnLFjnJzQKuKxbN03xLIQcx
	slrmS3e1RUcAi5/xwXvBEhPr6oIkMQhYg97ZPxUChtPS5XPwEixbqoDSxlHt+jsLiUK3HW
	Z70exQiuq6+7CyZjpWZzM9EN5CVrUn8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=deepplum.com;
	spf=pass (imf22.hostedemail.com: domain of dpreed@deepplum.com designates 173.203.187.69 as permitted sender) smtp.mailfrom=dpreed@deepplum.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758052344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0PJyo5BcFaiwNeFFwE5F2h6g/baorK0H4+X2CVnN88I=;
	b=VpnBukUvVkAgd5jrvuzUw8EusJ/auSBd1MVFdW+BZ8FtsQtXn+nZuU6sxaPcv/qhWbHfZu
	DNjlLf0fiC90liM3OYTSkjPp7Dh78PPW43qFChJx+ihNqMjAM59jWx5vCFUXfvGKoE8XLa
	SzMcv7ms+OAWOjy1XX7VMFRPQmsDeuQ=
Received: from app38.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp1.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 141E742D9;
	Tue, 16 Sep 2025 15:52:24 -0400 (EDT)
Received: from deepplum.com (localhost.localdomain [127.0.0.1])
	by app38.wa-webapps.iad3a (Postfix) with ESMTP id EDAB6E1C4F;
	Tue, 16 Sep 2025 15:52:23 -0400 (EDT)
Received: by apps.rackspace.com
    (Authenticated sender: dpreed@deepplum.com, from: dpreed@deepplum.com) 
    with HTTP; Tue, 16 Sep 2025 15:52:23 -0400 (EDT)
X-Auth-ID: dpreed@deepplum.com
Date: Tue, 16 Sep 2025 15:52:23 -0400 (EDT)
Subject: =?utf-8?Q?Re=3A_PROBLEM=3A_userfaultfd_REGISTER_minor_mode_on_MAP=5FPRIVA?=
 =?utf-8?Q?TE_range_fails?=
From: "David P. Reed" <dpreed@deepplum.com>
To: "Axel Rasmussen" <axelrasmussen@google.com>
Cc: "Peter Xu" <peterx@redhat.com>,
 "James Houghton" <jthoughton@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com>
References: <1757967196.153116687@apps.rackspace.com> 
 <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com> 
 <1757977128.137610687@apps.rackspace.com> 
 <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com> 
 <aMl4qLyNovWHhty9@x1.local> <1758037938.96199037@apps.rackspace.com> 
 <aMmMnfU-Koopc9mL@x1.local> <1758043654.112619688@apps.rackspace.com> 
 <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com>
X-Client-IP: 209.6.168.128
Message-ID: <1758052343.971831541@apps.rackspace.com>
X-Mailer: webmail/19.0.28-RC
X-Classification-ID: d7fee7dd-fca1-4b9c-a6c8-b2e538fdcea2-1-1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D7745C0008
X-Stat-Signature: 1pp6apctbiiqisjc44oxahy64b73635a
X-Rspam-User: 
X-HE-Tag: 1758052344-732411
X-HE-Meta: U2FsdGVkX188eFQv0AL8Qo9B7nrkKz1dBwMdXyrFU+w0iGjTi4O2gkAOu1+q5n4BZg43r16HbOXZVN9GEFqOdGAG4lTnok4Jl9LqQCpI83tGx7DkThrwT9YVCyyMX5WVDKH0xq0Obyo8aD2z1zv0JziIA1w2QfOm9VmJjxx6uM0HKS4KK5sz6tD3TmRaTrGpP+cpvwDWNJUmKjPDXVI5wsVGr7HohAZS+00jECNQp6HlsdLSWp7cPY0AwSKsCDLoHRuj20Qr6Mf8GYnNonS+KpB5q3uGXioC/2mKu4/SYYr455vhNKQEHWnwRL0jygf1cbEuYVbbQjSUWwWBJe7OyBqu65y921ZMyrFUhSrbxmWTkdQDRvZj6R2bwUJ3uJ7ukQ0ej3osvtQoGn52DI6uHk24zQUchuRq9o9PZGYcVrdjDeb2nHp2YSNubtLibIMrrE9d2eLO/mY6mFpnpqICklkFQVmQ0y+rMaLRDMGoyt/q4uU/s118CojbY5Mk8RkjRXPA1BO4QNvqsFKXB2vsTQVdtrF6HUWwkpdhk5nFa/DQqLgZTW1RAZ/mqA5lP16vytUvFYna6iJyjA7Hh8kIPPmuAYsFUs+ElPgJKQ5lzDmv51rcU+asrSZ/Pj87YuA1D9WvSya8YYeniFLHQd6iCHweZfeAAKFxcV1AF0k8qItTuMtXC7tBYvBxT14eP8VD2xrWz0id9RMXj5BJp3Vl4joXGkzOwezEYbMglj5Lt6QnBDxqtz+5Nu+DOU2WnQKfl4SQmufhFbPR0V6HX5/4I5J27z588VCT5MjnYV2VJskstcjKOVN3jkTmLhmkeFSYpaKVoK+vCLRxliX/BKvKRgOIKb2ZJ7p4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

=0A=0AOn Tuesday, September 16, 2025 14:35, "Axel Rasmussen" <axelrasmussen=
@google.com> said:=0A=0A> On Tue, Sep 16, 2025 at 10:27=E2=80=AFAM David P.=
 Reed <dpreed@deepplum.com> wrote:=0A> =0A>> Than -=0A>>=0A>> Just to clari=
fy -=0A>> Looking at the man page for UFFDIO_API, there are two "feature bi=
ts" that=0A>> indicate cases where "minor" handling is now supported, and c=
an be enabled.=0A>> UFFD_FEATURE_MINOR_HUGETLBFS and UFFD_FEATURE_MINOR_SHM=
EM=0A>> In my reading of the documents, these seem to imply that before the=
y were=0A>> added as new features, that MAP_PRIVATE|MAP_ANONYMOUS mappings =
were=0A>> supported, and that the "new" additions to the MINOR mode were ju=
st for=0A>> HUGETLBFS and MAP_SHARED cases.=0A>>=0A> =0A> Actually minor fa=
ult support didn't exist at all before those two features=0A> were added. :=
)=0A=0AThanks for commenting. I'm not sure that's exactly true. Why is SNME=
M (MAP_SHARED) supported, but not ordinary pages? I wasn't party to the evo=
lution here, but so far no one has explained why there's a special differen=
ce between SHMEM and ordinary VMAs.=0A=0A> =0A> You are right that userfaul=
tfd's use of "minor fault" is (unfortunately)=0A> slightly different from t=
he meaning in other contexts. I think the more=0A> normal meaning is, fault=
s which do not incur I/O (i.e., swap faults and=0A> file faults [i.e., faul=
ts on non-swap-backed pages] are major, other faults=0A> are minor).=0A> =
=0A> For userfaultfd, a minor fault is a fault where the page already exist=
s in=0A> the page cache, but the page table entry wasn't setup. I don't thi=
nk that=0A> scenario can ever happen for anonymous, private mappings, so it=
 doesn't=0A> really make sense to be able to register such mappings in this=
 mode. If you=0A> create a mapping with mmap(MAP_ANON|MAP_PRIVATE) and then=
 access it (read=0A> or write), that fault requires allocation of a new pag=
e, so userfaultfd=0A> does not consider that a "minor fault". My recollecti=
on though is if you=0A> make a file on tmpfs or hugetlbfs, fallocate() it o=
r whatever, and you=0A> MAP_PRIVATE that file, *that* registration will wor=
k.=0A> =0A> =0A>>=0A>> It seems odd that anonymous page faults and COW woul=
d not be handled,=0A>> given that context.=0A>>=0A>> Anyway, that's unclear=
 in any of the documentation. This just adds to my=0A>> last response where=
 I explain my use case.=0A>>=0A>>=0A>>=0A> =0A


